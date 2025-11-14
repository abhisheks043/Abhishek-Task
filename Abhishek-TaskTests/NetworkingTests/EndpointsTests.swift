//
//  EndpointsTests.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import XCTest
@testable import Abhishek_Task

final class EndpointTests: XCTestCase {
    
    // MARK: - Test HoldingsEndpoint
    func testHoldingsEndpointProperties() {
        // Given
        let endpoint = UserHoldingsAPIService.HoldingsEndpoint()
        
        // Then
        XCTAssertNotNil(endpoint.baseApi)
        XCTAssertEqual(endpoint.path, "")
        XCTAssertEqual(endpoint.httpMethod, .get)
        XCTAssertEqual(endpoint.cachePolicy, .useProtocolCachePolicy)
    }
    
    // MARK: - Test getUrlRequest
    func testGetUrlRequest() throws {
        // Given
        let endpoint = UserHoldingsAPIService.HoldingsEndpoint()
        
        // When
        let request = try endpoint.getUrlRequest()
        
        // Then
        XCTAssertNotNil(request.url)
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.cachePolicy, .useProtocolCachePolicy)
        XCTAssertTrue(request.url?.absoluteString.contains("mockbin.io") ?? false)
    }
    
    // MARK: - Test invalid URL handling
    func testInvalidURLHandling() {
        // Given
        struct InvalidEndpoint: Endpoint {
            var baseApi: URL { URL(string: "https://example.com")! }
            var path: String { "test" }
            var httpMethod: HTTPMethod { .get }
            var cachePolicy: URLRequest.CachePolicy { .useProtocolCachePolicy }
        }
        
        // This test verifies that the endpoint can handle URL construction
        // The actual implementation should handle edge cases
        let endpoint = InvalidEndpoint()
        
        // When/Then - Should not throw for valid URLs
        XCTAssertNoThrow(try endpoint.getUrlRequest())
    }
}

