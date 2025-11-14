//
//  Double+PriceFormatting.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import Foundation

extension Double {
    func formattedPrice() -> String {
        // If it has decimal places, format with up to 2 decimal places
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        if let formatted = formatter.string(from: NSNumber(value: self)) {
            return "₹ \(formatted)"
        } else {
            return "₹ \(self)"
        }
    }
}

