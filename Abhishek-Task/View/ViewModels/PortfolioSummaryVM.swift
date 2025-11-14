//
//  PortfolioSummaryVM.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import Foundation

protocol PortfolioSummaryVMProtocol {
    var summary: PortfolioSummary? { get }
    func calculateSummary(from holdings: [Holding])
}

class PortfolioSummaryVM: PortfolioSummaryVMProtocol {
    private(set) var summary: PortfolioSummary?
    
    /*
     Calculation:
     1. Current value = sum of (Last traded price * quantity of holding ) of all the holdings
     2. Total investment = sum of (Average Price * quantity of holding ) of all the holdings
     3. Total PNL = Current value - Total Investment
     4. Today’s PNL = sum of ((Close - LTP ) * quantity) of all the holdings
     */
    func calculateSummary(from holdings: [Holding]) {
        let currentValue = holdings.reduce(0.0) { $0 + ($1.ltp * Double($1.quantity)) }
        
        let totalInvestment = holdings.reduce(0.0) { $0 + ($1.avgPrice * Double($1.quantity)) }
        
        let totalPNL = currentValue - totalInvestment
        
        let todaysPNL = holdings.reduce(0.0) { $0 + (($1.close - $1.ltp) * Double($1.quantity)) }
        
        summary = PortfolioSummary(
            currentValue: currentValue,
            totalInvestment: totalInvestment,
            totalPNL: totalPNL,
            todaysPNL: todaysPNL
        )
    }
}

