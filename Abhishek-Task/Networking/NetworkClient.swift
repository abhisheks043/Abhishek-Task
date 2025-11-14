//
//  NetworkClient.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case server(statusCode: Int, data: Data?)
    case decodingError(Error)
    case transport(Error)
    case noInternet
}

protocol NetworkClientProtocol {
    func send<T: Codable>(request: Endpoint) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    func send<T>(request: Endpoint) async throws -> T where T : Codable {
        guard NetworkMonitor.shared.isConnected else {
            throw NetworkError.noInternet
        }
        
        let request = try request.getUrlRequest()
        do {
            // get response and data from request
            let (data, response) = try await session.data(for: request)
            
            // check for valid response
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // check for valid status code
            guard (200...299).contains(response.statusCode) else {
                throw NetworkError.server(statusCode: response.statusCode, data: data)
            }
            
            // decode data
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            throw NetworkError.decodingError(error)
        } catch {
            throw NetworkError.transport(error)
        }
    }
}
