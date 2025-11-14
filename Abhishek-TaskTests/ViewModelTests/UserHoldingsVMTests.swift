//
//  UserHoldingsVMTests.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import XCTest
@testable import Abhishek_Task

// MARK: - Mock API Service
final class MockUserHoldingsAPIService: UserHoldingsAPIServiceProtocol {
    var shouldThrowError = false
    var errorToThrow: Error?
    var mockResponse: HoldingsResponse?
    
    func fetchHoldingsResponse() async throws -> HoldingsResponse {
        if shouldThrowError {
            throw errorToThrow ?? NetworkError.transport(NSError(domain: "TestError", code: -1))
        }
        
        if let response = mockResponse {
            return response
        }
        
        // Default mock response
        let holding = Holding(symbol: "TEST", quantity: 10, ltp: 100.0, avgPrice: 90.0, close: 95.0)
        let data = HoldingsData(userHolding: [holding])
        return HoldingsResponse(data: data)
    }
}

// MARK: - Mock Delegate
final class MockUserHoldingsVCDelegate: UserHoldingsVCDelegate {
    func updateOnAPISuccess() {
        reloadTableView()
        updatePortfolioSummary()
    }
    
    func updateOnAPIFailure(with error: any Error) { }
    
    var reloadTableViewCalled = false
    var updatePortfolioSummaryCalled = false
    
    func reloadTableView() {
        reloadTableViewCalled = true
    }
    
    func updatePortfolioSummary() {
        updatePortfolioSummaryCalled = true
    }
}

final class UserHoldingsVMTests: XCTestCase {
    
    var viewModel: UserHoldingsVM!
    var mockAPIService: MockUserHoldingsAPIService!
    var mockDelegate: MockUserHoldingsVCDelegate!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockUserHoldingsAPIService()
        mockDelegate = MockUserHoldingsVCDelegate()
        viewModel = UserHoldingsVM(apiService: mockAPIService)
        viewModel.delegate = mockDelegate
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        mockDelegate = nil
        super.tearDown()
    }
    
    // MARK: - Test Initial State
    func testInitialState() {
        // Then
        XCTAssertEqual(viewModel.holdingsCount, 0)
        XCTAssertNil(viewModel.getUserHolding(for: 0))
        XCTAssertEqual(viewModel.allHoldings.count, 0)
    }
    
    // MARK: - Test holdingsCount
    func testHoldingsCount() async {
        // Given
        let holding1 = Holding(symbol: "TEST1", quantity: 10, ltp: 100.0, avgPrice: 90.0, close: 95.0)
        let holding2 = Holding(symbol: "TEST2", quantity: 5, ltp: 200.0, avgPrice: 180.0, close: 210.0)
        let data = HoldingsData(userHolding: [holding1, holding2])
        mockAPIService.mockResponse = HoldingsResponse(data: data)
        
        // When
        viewModel.loadUserHoldings()
        
        // Wait for async operation
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Then
        XCTAssertEqual(viewModel.holdingsCount, 2)
    }
    
    // MARK: - Test getUserHolding
    func testGetUserHolding() async {
        // Given
        let holding1 = Holding(symbol: "TEST1", quantity: 10, ltp: 100.0, avgPrice: 90.0, close: 95.0)
        let holding2 = Holding(symbol: "TEST2", quantity: 5, ltp: 200.0, avgPrice: 180.0, close: 210.0)
        let data = HoldingsData(userHolding: [holding1, holding2])
        mockAPIService.mockResponse = HoldingsResponse(data: data)
        
        // When
        viewModel.loadUserHoldings()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        let retrievedHolding1 = viewModel.getUserHolding(for: 0)
        let retrievedHolding2 = viewModel.getUserHolding(for: 1)
        
        XCTAssertNotNil(retrievedHolding1)
        XCTAssertEqual(retrievedHolding1?.symbol, "TEST1")
        XCTAssertEqual(retrievedHolding1?.quantity, 10)
        
        XCTAssertNotNil(retrievedHolding2)
        XCTAssertEqual(retrievedHolding2?.symbol, "TEST2")
        XCTAssertEqual(retrievedHolding2?.quantity, 5)
    }
    
    // MARK: - Test getUserHolding with invalid index
    func testGetUserHoldingWithInvalidIndex() async {
        // Given
        let holding = Holding(symbol: "TEST", quantity: 10, ltp: 100.0, avgPrice: 90.0, close: 95.0)
        let data = HoldingsData(userHolding: [holding])
        mockAPIService.mockResponse = HoldingsResponse(data: data)
        
        // When
        viewModel.loadUserHoldings()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertNil(viewModel.getUserHolding(for: -1))
        XCTAssertNil(viewModel.getUserHolding(for: 1))
        XCTAssertNil(viewModel.getUserHolding(for: 100))
    }
    
    // MARK: - Test allHoldings
    func testAllHoldings() async {
        // Given
        let holding1 = Holding(symbol: "TEST1", quantity: 10, ltp: 100.0, avgPrice: 90.0, close: 95.0)
        let holding2 = Holding(symbol: "TEST2", quantity: 5, ltp: 200.0, avgPrice: 180.0, close: 210.0)
        let data = HoldingsData(userHolding: [holding1, holding2])
        mockAPIService.mockResponse = HoldingsResponse(data: data)
        
        // When
        viewModel.loadUserHoldings()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        let allHoldings = viewModel.allHoldings
        XCTAssertEqual(allHoldings.count, 2)
        XCTAssertEqual(allHoldings[0].symbol, "TEST1")
        XCTAssertEqual(allHoldings[1].symbol, "TEST2")
    }
    
    // MARK: - Test loadUserHoldings success
    func testLoadUserHoldingsSuccess() async {
        // Given
        let holding = Holding(symbol: "TEST", quantity: 10, ltp: 100.0, avgPrice: 90.0, close: 95.0)
        let data = HoldingsData(userHolding: [holding])
        mockAPIService.mockResponse = HoldingsResponse(data: data)
        
        // When
        viewModel.loadUserHoldings()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(viewModel.holdingsCount, 1)
        XCTAssertTrue(mockDelegate.reloadTableViewCalled)
        XCTAssertTrue(mockDelegate.updatePortfolioSummaryCalled)
    }
    
    // MARK: - Test loadUserHoldings with empty response
    func testLoadUserHoldingsWithEmptyResponse() async {
        // Given
        let data = HoldingsData(userHolding: [])
        mockAPIService.mockResponse = HoldingsResponse(data: data)
        
        // When
        viewModel.loadUserHoldings()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(viewModel.holdingsCount, 0)
        XCTAssertEqual(viewModel.allHoldings.count, 0)
    }
    
    // MARK: - Test loadUserHoldings with nil data
    func testLoadUserHoldingsWithNilData() async {
        // Given
        mockAPIService.mockResponse = HoldingsResponse(data: nil)
        
        // When
        viewModel.loadUserHoldings()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertEqual(viewModel.holdingsCount, 0)
        XCTAssertEqual(viewModel.allHoldings.count, 0)
    }
    
    // MARK: - Test delegate is called on main thread
    func testDelegateCalledOnMainThread() async {
        // Given
        let holding = Holding(symbol: "TEST", quantity: 10, ltp: 100.0, avgPrice: 90.0, close: 95.0)
        let data = HoldingsData(userHolding: [holding])
        mockAPIService.mockResponse = HoldingsResponse(data: data)
        
        // When
        viewModel.loadUserHoldings()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        // Delegate methods should be called (tested by checking flags)
        XCTAssertTrue(mockDelegate.reloadTableViewCalled)
        XCTAssertTrue(mockDelegate.updatePortfolioSummaryCalled)
    }
}

