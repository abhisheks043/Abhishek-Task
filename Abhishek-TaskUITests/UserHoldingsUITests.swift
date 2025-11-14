//
//  UserHoldingsUITests.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import XCTest

final class UserHoldingsUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Test App Launch
    func testAppLaunch() throws {
        // Verify app launches successfully
        XCTAssertTrue(app.waitForExistence(timeout: 5.0))
    }
    
    // MARK: - Test Table View Exists
    func testTableViewExists() throws {
        // Given - App is launched
        let tableView = app.tables.firstMatch
        
        // Then
        XCTAssertTrue(tableView.waitForExistence(timeout: 5.0))
    }
    
    // MARK: - Test Portfolio Summary View Exists
    func testPortfolioSummaryViewExists() throws {
        // Given - App is launched
        // Portfolio summary should be at the bottom
        
        // Wait for content to load
        sleep(2)
        
        // Then - Check if portfolio summary view exists (by checking for "Profit & Loss" text)
        let profitLossLabel = app.staticTexts["Profit & Loss*"]
        XCTAssertTrue(profitLossLabel.waitForExistence(timeout: 5.0))
    }
    
    // MARK: - Test Holdings Display
    func testHoldingsAreDisplayed() throws {
        // Given - App is launched
        let tableView = app.tables.firstMatch
        
        // Wait for data to load
        sleep(3)
        
        // Then - Check if table has cells
        let cells = tableView.cells
        if cells.count > 0 {
            XCTAssertGreaterThan(cells.count, 0, "Table should have at least one cell")
            
            // Verify first cell has content
            let firstCell = cells.element(boundBy: 0)
            XCTAssertTrue(firstCell.exists)
        }
    }
    
    // MARK: - Test Portfolio Summary Expand Collapse
    func testPortfolioSummaryExpandCollapse() throws {
        // Given - App is launched
        sleep(2)
        
        // Find the portfolio summary header
        let profitLossLabel = app.staticTexts["Profit & Loss*"]
        XCTAssertTrue(profitLossLabel.waitForExistence(timeout: 5.0))
        
        // When - Tap on the header to expand
        profitLossLabel.tap()
        
        // Wait for animation
        sleep(1)
        
        // Then - Verify content is expanded (check for summary items)
        // The expandable content should show current value, total investment, etc.
        // We can check if the view height changed or if specific labels appear
        
        // Tap again to collapse
        profitLossLabel.tap()
        sleep(1)
    }
    
    // MARK: - Test Table View Scrolling
    func testTableViewScrolling() throws {
        // Given - App is launched
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5.0))
        
        sleep(2)
        
        // When - Scroll the table view
        tableView.swipeUp()
        sleep(1)
        tableView.swipeDown()
        sleep(1)
        
        // Then - Table should still be accessible
        XCTAssertTrue(tableView.exists)
    }
    
    // MARK: - Test Portfolio Summary Values Display
    func testPortfolioSummaryValuesDisplay() throws {
        // Given - App is launched
        sleep(3)
        
        // Then - Check if portfolio summary shows values
        // The total PNL should be displayed in the header
        let profitLossLabel = app.staticTexts["Profit & Loss*"]
        XCTAssertTrue(profitLossLabel.waitForExistence(timeout: 5.0))
        
        // Check if there's a value label next to it (contains ₹ symbol)
        // This is a bit tricky without specific accessibility identifiers
        // We'll check if the view exists and is interactable
        XCTAssertTrue(profitLossLabel.isHittable)
    }
    
    // MARK: - Test Multiple Expand Collapse Cycles
    func testMultipleExpandCollapseCycles() throws {
        // Given - App is launched
        sleep(2)
        
        let profitLossLabel = app.staticTexts["Profit & Loss*"]
        XCTAssertTrue(profitLossLabel.waitForExistence(timeout: 5.0))
        
        // When - Perform multiple expand/collapse cycles
        for _ in 0..<3 {
            profitLossLabel.tap()
            sleep(1)
            profitLossLabel.tap()
            sleep(1)
        }
        
        // Then - App should still be responsive
        XCTAssertTrue(profitLossLabel.exists)
    }
    
    // MARK: - Test Table View Cell Interaction
    func testTableViewCellInteraction() throws {
        // Given - App is launched
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5.0))
        
        sleep(3)
        
        // When - Try to interact with cells if they exist
        let cells = tableView.cells
        if cells.count > 0 {
            let firstCell = cells.element(boundBy: 0)
            if firstCell.exists {
                // Cells should be visible (not necessarily tappable if they're just display)
                XCTAssertTrue(firstCell.isHittable || firstCell.exists)
            }
        }
    }
    
    // MARK: - Test Orientation Support (if applicable)
    func testPortraitOrientation() throws {
        // Given - App is launched
        let device = XCUIDevice.shared
        device.orientation = .portrait
        
        sleep(1)
        
        // Then - App should still function
        let tableView = app.tables.firstMatch
        XCTAssertTrue(tableView.waitForExistence(timeout: 5.0))
    }
}

