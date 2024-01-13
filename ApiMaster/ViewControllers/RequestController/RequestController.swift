//
//  RequestController.swift
//  ApiMaster
//
//  Created by Taron Vekilyan on 12.01.24.
//

import Foundation
class RequestController<T: Decodable> {
    
    // MARK: - Properties
    
    private let baseURL: URL
    
    // MARK: - Initialization
    
    init() {
        self.baseURL = URL(string: "https://b35b-37-252-94-26.ngrok-free.app")!
    }
    
    // MARK: - Public Methods
    
    func fetchData(endpoint: String, parameters: [String: Any]? = nil, completion: @escaping (Result<T?, Error>) -> Void) {
        performRequest(endpoint: endpoint, method: "GET", parameters: parameters, completion: completion)
    }
    
    func sendData(endpoint: String, method: String = "POST", parameters: [String: Any]? = nil, completion: @escaping (Result<T?, Error>) -> Void) {
        performRequest(endpoint: endpoint, method: method, parameters: parameters, completion: completion)
    }
    
    func updateData(endpoint: String, parameters: [String: Any]? = nil, completion: @escaping (Result<T?, Error>) -> Void) {
        performRequest(endpoint: endpoint, method: "PUT", parameters: parameters, completion: completion)
    }
    
    func deleteData(endpoint: String, parameters: [String: Any]? = nil, completion: @escaping (Result<T?, Error>) -> Void) {
        performRequest(endpoint: endpoint, method: "DELETE", parameters: parameters, completion: completion)
    }
    
    // MARK: - Private Methods
    
    private func performRequest(endpoint: String, method: String, parameters: [String: Any]? = nil, completion: @escaping (Result<T?, Error>) -> Void) {
        // Construct the full URL by appending the endpoint to the base URL
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: true)
        if method == "GET" {
            urlComponents?.queryItems = parameters?.compactMap { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let fullURL = urlComponents?.url else {
            let error = NSError(domain: "URLConstructionError", code: -1, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        // Create a URLRequest with the specified method
        var request = URLRequest(url: fullURL)
        request.httpMethod = method
        
        // Set request body for POST and PUT requests
        if let parameters = parameters, method == "POST" || method == "PUT" {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        // Create a URLSession and data task to perform the request
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle the response
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "HTTPError", code: statusCode, userInfo: nil)
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NoDataError", code: -1, userInfo: nil)
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            // Decode the JSON data using the provided generic type
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try decoder.decode(ResponseModel<T>.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(decodedData.response))
                }
            } catch {
                print(error)
                
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        
        // Start the data task
        task.resume()
    }
}

struct ResponseModel<T: Decodable>: Decodable {
    let response: T?
}

extension Encodable {
    var dictionary: [String: Any]? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
