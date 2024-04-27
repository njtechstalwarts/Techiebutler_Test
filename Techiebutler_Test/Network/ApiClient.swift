//
//  ApiClient.swift
//  MP Papers
//
//  Created by techstalwarts on 30/11/23.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidResponse
    case invalidData
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error>
}

class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    
    func makeComponents(endpoint: APIEndpoint) -> URLRequest? {
        var components = URLComponents()
        components.scheme = AppConstants.scheme.rawValue
        components.host = AppConstants.baseUrl.rawValue
        
        if !AppConstants.port.rawValue.isEmpty {
            components.port = Int(AppConstants.port.rawValue)
        }
        
        components.path = endpoint.path
        
        DLog(message: components.queryItems)
        
        let httpMethod = endpoint.method
        
        if httpMethod == .get {
            if endpoint.parameters?.isEmpty == false {
                components.queryItems = endpoint.parameters?.map { element in
                    URLQueryItem(name: element.key, value: "\(element.value)")
                }
            }
        }

        DLog(message: components.url)
        DLog(message: endpoint.parameters)
        
        var request = URLRequest(url: components.url!)
        request.timeoutInterval = 60
        
        request.httpMethod = httpMethod.rawValue
        if httpMethod == .post || httpMethod == .put || httpMethod == .delete {
            let params = endpoint.parameters ?? [:]
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
    
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error> {
        guard let request = makeComponents(endpoint: endpoint) else {
            return Fail(error: NSError(domain: "URL Malformed", code: -10001, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                    return data
                } else {
                    throw APIError.invalidResponse
                }
            }
            .map({ data in
                if type(of: T.self) == String.Type.self {
                    let string = (String(data: data, encoding: .utf8) ?? "")
                    return string as! T
                } else {
                    return try! JSONDecoder().decode(T.self, from: data)
                }
            })
            .eraseToAnyPublisher()
    }
    
    
}
