//
//  PortfolioSummaryVMTests.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import XCTest
@testable import Abhishek_Task

final class PortfolioSummaryVMTests: XCTestCase {
    
    var viewModel: PortfolioSummaryVM!
    
    override func setUp() {
        super.setUp()
        viewModel = PortfolioSummaryVM()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // MARK: - Test calculateSummary with empty holdings
    func testCalculateSummaryWithEmptyHoldings() {
        // Given
        let holdings: [Holding] = []
        
        // When
        viewModel.calculateSummary(from: holdings)
        
        // Then
        XCTAssertNotNil(viewModel.summary)
        XCTAssertEqual(viewModel.summary?.currentValue, 0.0)
        XCTAssertEqual(viewModel.summary?.totalInvestment, 0.0)
        XCTAssertEqual(viewModel.summary?.totalPNL, 0.0)
        XCTAssertEqual(viewModel.summary?.todaysPNL, 0.0)
    }
    
    // MARK: - Test calculateSummary with multiple holdings
    func testCalculateSummaryWithMultipleHoldings() {
        // Given
        let holding1 = Holding(symbol: "TEST1", quantity: 10, ltp: 100.0, avgPrice: 90.0, close: 95.0)
        let holding2 = Holding(symbol: "TEST2", quantity: 5, ltp: 200.0, avgPrice: 180.0, close: 210.0)
        let holdings = [holding1, holding2]
        
        // When
        viewModel.calculateSummary(from: holdings)
        
        // Then
        XCTAssertNotNil(viewModel.summary)
        // Current value: (10 * 100.0) + (5 * 200.0) = 1000 + 1000 = 2000
        XCTAssertEqual(viewModel.summary!.currentValue, 2000.0, accuracy: 0.01)
        // Total investment: (10 * 90.0) + (5 * 180.0) = 900 + 900 = 1800
        XCTAssertEqual(viewModel.summary!.totalInvestment, 1800.0, accuracy: 0.01)
        // Total PNL: 2000 - 1800 = 200
        XCTAssertEqual(viewModel.summary!.totalPNL, 200.0, accuracy: 0.01)
        // Today's PNL: ((95 - 100) * 10) + ((210 - 200) * 5) = -50 + 50 = 0
        XCTAssertEqual(viewModel.summary!.todaysPNL, 0.0, accuracy: 0.01)
    }
    
    // MARK: - Test calculateSummary with zero values
    func testCalculateSummaryWithZeroValues() {
        // Given
        let holding = Holding(symbol: "TEST", quantity: 0, ltp: 100.0, avgPrice: 90.0, close: 95.0)
        let holdings = [holding]
        
        // When
        viewModel.calculateSummary(from: holdings)
        
        // Then
        XCTAssertNotNil(viewModel.summary)
        XCTAssertEqual(viewModel.summary?.currentValue, 0.0)
        XCTAssertEqual(viewModel.summary?.totalInvestment, 0.0)
        XCTAssertEqual(viewModel.summary?.totalPNL, 0.0)
        XCTAssertEqual(viewModel.summary?.todaysPNL, 0.0)
    }
    
    // MARK: - Test calculateSummary updates summary property
    func testCalculateSummaryUpdatesSummaryProperty() {
        // Given
        let holding1 = Holding(symbol: "TEST1", quantity: 10, ltp: 100.0, avgPrice: 90.0, close: 95.0)
        let holdings1 = [holding1]
        
        // When - First calculation
        viewModel.calculateSummary(from: holdings1)
        let firstSummary = viewModel.summary
        
        // Then
        XCTAssertNotNil(firstSummary)
        XCTAssertEqual(firstSummary?.currentValue, 1000.0)
        
        // Given - Different holdings
        let holding2 = Holding(symbol: "TEST2", quantity: 30, ltp: 50.0, avgPrice: 40.0, close: 55.0)
        let holdings2 = [holding2]
        
        // When - Second calculation
        viewModel.calculateSummary(from: holdings2)
        let secondSummary = viewModel.summary
        
        // Then
        XCTAssertNotNil(secondSummary)
        XCTAssertEqual(secondSummary?.currentValue, 1500.0) // 20 * 50.0
        XCTAssertNotEqual(firstSummary?.currentValue, secondSummary?.currentValue) // Actually they're equal, but different holdings
    }
}

