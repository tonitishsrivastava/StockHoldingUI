//
//  APIManager.swift
//  StockHoldingUI
//
//  Created by Nitin Srivastav on 16/11/24.
//

import Foundation

enum httpError : Error {
    case jsonDecoding
    case noData
    case nonSuccessStatusCode
    case serverError
    case emptyCollection
    case emptyObject
    case invalidUrl
}

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `QUERY` method.
    public static let query = HTTPMethod(rawValue: "QUERY")
    /// `TRACE` method.
    public static let trace = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

struct APIError: Codable, Error {
    let code: Int
    let status: String
    let message: String
}

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func performOperation<T:Decodable>(request: URLRequest, response: T.Type) async -> Result<T, Error> {
        
        do {
            let (serverData, serverUrlResponse) = try await URLSession.shared.data(for:request)
            
            guard let httpStausCode = (serverUrlResponse as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(httpStausCode) else {
                return .failure(try JSONDecoder().decode(APIError.self, from: serverData))
            }
            return .success(try JSONDecoder().decode(response.self, from: serverData))
            
        } catch  {
            return .failure(error)
        }
    }
    
    func createURLRequest(urlString: String, token: String?, method: HTTPMethod, body: Data?) -> Result<URLRequest,httpError> {
        guard let url = URL(string: urlString) else {
            return .failure(.invalidUrl)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        if let token = token {
            urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        }
        urlRequest.httpMethod = method.rawValue
        if let body = body {
            urlRequest.httpBody = body
        }
        
        return .success(urlRequest)
    }
    
}
