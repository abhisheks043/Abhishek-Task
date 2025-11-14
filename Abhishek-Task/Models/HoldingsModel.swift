//
//  HoldingsModel.swift
//  Abhishek-Task
//
//  Created by Abhishek on 12/11/25.
//

import Foundation

struct Holding: Codable {
    let symbol: String
    let quantity: Int
    let ltp: Double
    let avgPrice: Double
    let close: Double
    
    
    var currentValue: Double {
        return Double(quantity) * ltp
    }
    
    var investmentValue: Double {
        return Double(quantity) * avgPrice
    }
    
    var pnl: Double {
        return currentValue - investmentValue
    }
    
    var pnlPercentage: Double {
        return (pnl / investmentValue) * 100
    }
}

struct HoldingsResponse: Codable {
    let data: HoldingsData?
}

struct HoldingsData: Codable {
    let userHolding: [Holding]?
}
