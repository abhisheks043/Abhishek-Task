//
//  NetworkClientTests.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import XCTest
@testable import Abhishek_Task

final class MockSession: NetworkClientProtocol {
    var shouldThrowError = false
    var errorToThrow: Error?
    var statusCode: Int = 200
    var mockJSON: String?
    
    func send<T>(request: any Abhishek_Task.Endpoint) async throws -> T where T : Decodable, T : Encodable {
        if shouldThrowError {
            throw errorToThrow ?? NetworkError.transport(NSError(domain: "TestError", code: -1))
        }
        
        let json = mockJSON ?? """
            {
                "data": {
                    "userHolding": [
                        {
                            "symbol": "MAHABANK",
                            "quantity": 990,
                            "ltp": 38.05,
                            "avgPrice": 35,
                            "close": 40
                        }
                    ]
                }
            }
            """
        let data = Data(json.utf8)
        
        let endpoint = UserHoldingsAPIService.HoldingsEndpoint()
        let url = endpoint.baseApi.appending(path: endpoint.path)
        let response = HTTPURLResponse(url: url,
                                       statusCode: statusCode,
                                       httpVersion: nil,
                                       headerFields: nil)!
        
        // Check status code like a real network client
        guard (200..<300).contains(response.statusCode) else {
            throw NetworkError.server(statusCode: response.statusCode, data: data)
        }
        
        // Decode JSON
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}

final class NetworkClientTests: XCTestCase {
    
    var mockSession: MockSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockSession()
    }
    
    override func tearDown() {
        mockSession = nil
        super.tearDown()
    }
    
    // MARK: - Test successful request and decode
    func testSendAndDecodesValidJSON() async throws {
        // Given
        let holding = Holding(symbol: "MAHABANK", quantity: 990, ltp: 38.05, avgPrice: 35, close: 40)
        
        // When
        let holdingsRespData: HoldingsResponse = try await mockSession.send(request: UserHoldingsAPIService.HoldingsEndpoint())
        
        // Then
        XCTAssertEqual(holdingsRespData.data?.userHolding?.count, 1)
        XCTAssertEqual(holdingsRespData.data?.userHolding?.first?.symbol, holding.symbol)
        XCTAssertEqual(holdingsRespData.data?.userHolding?.first?.quantity, holding.quantity)
        XCTAssertEqual(holdingsRespData.data?.userHolding?.first?.avgPrice, holding.avgPrice)
        XCTAssertEqual(holdingsRespData.data?.userHolding?.first?.close, holding.close)
    }
    
    // MARK: - Test server error handling
    func testSendWithServerError() async {
        // Given
        mockSession.statusCode = 500
        
        // When/Then
        do {
            let _: HoldingsResponse = try await mockSession.send(request: UserHoldingsAPIService.HoldingsEndpoint())
            XCTFail("Expected error to be thrown")
        } catch {
            if case NetworkError.server(let statusCode, _) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Expected server error")
            }
        }
    }
    
    // MARK: - Test 404 error
    func testSendWith404Error() async {
        // Given
        mockSession.statusCode = 404
        
        // When/Then
        do {
            let _: HoldingsResponse = try await mockSession.send(request: UserHoldingsAPIService.HoldingsEndpoint())
            XCTFail("Expected error to be thrown")
        } catch {
            if case NetworkError.server(let statusCode, _) = error {
                XCTAssertEqual(statusCode, 404)
            } else {
                XCTFail("Expected server error with 404")
            }
        }
    }
    
    // MARK: - Test decoding error
    func testSendWithInvalidJSON() async {
        // Given
        mockSession.mockJSON = "{ invalid json }"
        
        // When/Then
        do {
            let _: HoldingsResponse = try await mockSession.send(request: UserHoldingsAPIService.HoldingsEndpoint())
            XCTFail("Expected decoding error to be thrown")
        } catch {
            // Should throw decoding error
            XCTAssertTrue(error is DecodingError || error is NetworkError)
        }
    }
    
    // MARK: - Test transport error
    func testSendWithTransportError() async {
        // Given
        mockSession.shouldThrowError = true
        mockSession.errorToThrow = NetworkError.transport(NSError(domain: "NetworkError", code: -1009))
        
        // When/Then
        do {
            let _: HoldingsResponse = try await mockSession.send(request: UserHoldingsAPIService.HoldingsEndpoint())
            XCTFail("Expected transport error to be thrown")
        } catch {
            if case NetworkError.transport = error {
                // Expected
            } else {
                XCTFail("Expected transport error")
            }
        }
    }
    
    // MARK: - Test empty holdings response
    func testSendWithEmptyHoldings() async throws {
        // Given
        mockSession.mockJSON = """
            {
                "data": {
                    "userHolding": []
                }
            }
            """
        
        // When
        let holdingsRespData: HoldingsResponse = try await mockSession.send(request: UserHoldingsAPIService.HoldingsEndpoint())
        
        // Then
        XCTAssertNotNil(holdingsRespData.data)
        XCTAssertEqual(holdingsRespData.data?.userHolding?.count, 0)
    }
    
    // MARK: - Test multiple holdings
    func testSendWithMultipleHoldings() async throws {
        // Given
        mockSession.mockJSON = """
            {
                "data": {
                    "userHolding": [
                        {
                            "symbol": "MAHABANK",
                            "quantity": 990,
                            "ltp": 38.05,
                            "avgPrice": 35,
                            "close": 40
                        },
                        {
                            "symbol": "RELIANCE",
                            "quantity": 10,
                            "ltp": 2500.50,
                            "avgPrice": 2400,
                            "close": 2550
                        }
                    ]
                }
            }
            """
        
        // When
        let holdingsRespData: HoldingsResponse = try await mockSession.send(request: UserHoldingsAPIService.HoldingsEndpoint())
        
        // Then
        XCTAssertEqual(holdingsRespData.data?.userHolding?.count, 2)
        XCTAssertEqual(holdingsRespData.data?.userHolding?.first?.symbol, "MAHABANK")
        XCTAssertEqual(holdingsRespData.data?.userHolding?.last?.symbol, "RELIANCE")
    }
}
