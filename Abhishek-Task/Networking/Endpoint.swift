//
//  Endpoint.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
}

protocol Endpoint {
    var baseApi: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

extension Endpoint {
    func getUrlRequest() throws -> URLRequest {
        guard let components = URLComponents(url: baseApi.appending(path: path), resolvingAgainstBaseURL: false),
              let url = components.url else {
            throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: url, cachePolicy: cachePolicy)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}
