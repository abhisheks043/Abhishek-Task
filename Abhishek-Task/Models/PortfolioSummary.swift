//
//  PortfolioSummary.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import Foundation

struct PortfolioSummary {
    let currentValue: Double
    let totalInvestment: Double
    let totalPNL: Double
    let todaysPNL: Double
    
    var totalPNLPercentage: Double {
        guard totalInvestment != 0 else { return 0 }
        return (totalPNL / totalInvestment) * 100
    }
}

