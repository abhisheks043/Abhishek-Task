//
//  PortfolioSummaryModelTests.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//


import XCTest
@testable import Abhishek_Task

final class PortfolioSummaryModelTests: XCTestCase {
    
    // MARK: - Test PortfolioSummary properties
    func testPortfolioSummaryProperties() {
        // Given
        let summary = PortfolioSummary(
            currentValue: 2000.0,
            totalInvestment: 1800.0,
            totalPNL: 200.0,
            todaysPNL: 50.0
        )
        
        // Then
        XCTAssertEqual(summary.currentValue, 2000.0)
        XCTAssertEqual(summary.totalInvestment, 1800.0)
        XCTAssertEqual(summary.totalPNL, 200.0)
        XCTAssertEqual(summary.todaysPNL, 50.0)
    }
    
    // MARK: - Test totalPNLPercentage with large values
    func testTotalPNLPercentageWithLargeValues() {
        // Given
        let summary = PortfolioSummary(
            currentValue: 1000000.0,
            totalInvestment: 900000.0,
            totalPNL: 100000.0,
            todaysPNL: 50000.0
        )
        
        // When
        let percentage = summary.totalPNLPercentage
        
        // Then
        // (100000 / 900000) * 100 = 11.11...
        XCTAssertEqual(percentage, 100000.0 / 900000.0 * 100.0, accuracy: 0.01)
    }
    
    // MARK: - Test edge cases
    func testPortfolioSummaryWithNegativeValues() {
        // Given
        let summary = PortfolioSummary(
            currentValue: -100.0,
            totalInvestment: 100.0,
            totalPNL: -200.0,
            todaysPNL: -50.0
        )
        
        // When
        let percentage = summary.totalPNLPercentage
        
        // Then
        // (-200 / 100) * 100 = -200
        XCTAssertEqual(percentage, -200.0)
    }
}

