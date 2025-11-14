//
//  DoublePriceFormattingTests.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import XCTest
@testable import Abhishek_Task

final class DoublePriceFormattingTests: XCTestCase {
    
    // MARK: - Test whole numbers
    func testFormattedPriceWithZero() {
        // Given
        let value: Double = 0.0
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ 0")
    }
    
    func testFormattedPriceWithWholeNumber() {
        // Given
        let value: Double = 200.0
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ 200")
    }
    
    func testFormattedPriceWithLargeWholeNumber() {
        // Given
        let value: Double = 1000000.0
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ 10,00,000")
    }
    
    // MARK: - Test decimal numbers
    func testFormattedPriceWithOneDecimal() {
        // Given
        let value: Double = 200.5
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ 200.5")
    }
    
    func testFormattedPriceWithTwoDecimals() {
        // Given
        let value: Double = 200.50
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ 200.5")
    }
    
    func testFormattedPriceWithTwoDecimalsNonZero() {
        // Given
        let value: Double = 200.75
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ 200.75")
    }
    
    // MARK: - Test negative numbers
    func testFormattedPriceWithNegativeWholeNumber() {
        // Given
        let value: Double = -200.0
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ -200")
    }
    
    func testFormattedPriceWithNegativeDecimal() {
        // Given
        let value: Double = -200.50
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ -200.5")
    }
    
    // MARK: - Test small decimal values
    func testFormattedPriceWithSmallDecimal() {
        // Given
        let value: Double = 0.5
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ 0.5")
    }
    
    func testFormattedPriceWithVerySmallDecimal() {
        // Given
        let value: Double = 0.01
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ 0.01")
    }
    
    // MARK: - Test rounding behavior
    func testFormattedPriceWithMoreThanTwoDecimals() {
        // Given
        let value: Double = 200.123456
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        // Should round to 2 decimal places
        XCTAssertTrue(formatted.contains("₹"))
        XCTAssertTrue(formatted.contains("200"))
    }
    
    // MARK: - Test real-world scenarios
    func testFormattedPriceWithStockPrice() {
        // Given
        let value: Double = 38.05
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ 38.05")
    }
    
    func testFormattedPriceWithLargeAmount() {
        // Given
        let value: Double = 100000.50
        
        // When
        let formatted = value.formattedPrice()
        
        // Then
        XCTAssertEqual(formatted, "₹ 1,00,000.5")
    }
}
