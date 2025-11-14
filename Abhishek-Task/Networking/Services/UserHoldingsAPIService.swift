//
//  UserHoldingsAPIService.swift
//  Abhishek-Task
//
//  Created by Abhishek on 13/11/25.
//

import Foundation
import UIKit

protocol UserHoldingsAPIServiceProtocol {
    func fetchHoldingsResponse() async throws -> HoldingsResponse
}

class UserHoldingsAPIService {
    
    struct HoldingsEndpoint: Endpoint {
        var baseApi: URL { URL(string: "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/")! }
        var path: String { "" }
        var httpMethod: HTTPMethod { .get }
        var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
    }
    
    private let networkService: NetworkClientProtocol
    
    init(networkService: NetworkClientProtocol = NetworkClient()) {
        self.networkService = networkService
    }
}

extension UserHoldingsAPIService: UserHoldingsAPIServiceProtocol {
    func fetchHoldingsResponse() async throws -> HoldingsResponse {
        try await networkService.send(request: HoldingsEndpoint())
    }
}
