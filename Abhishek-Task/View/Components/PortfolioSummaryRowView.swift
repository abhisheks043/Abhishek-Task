//
//  PortfolioSummaryRowView.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import UIKit

// MARK: - PortfolioSummaryRowView
class PortfolioSummaryRowView: UIView {
    
    // MARK: - UI Components -
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    // MARK: - Initialization -
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Configuration -
    func configure(title: String, value: String, isPositive: Bool? = nil) {
        titleLabel.text = title
        valueLabel.text = value
        
        if let isPositive = isPositive {
            valueLabel.textColor = isPositive ? .systemGreen : .systemRed
        } else {
            valueLabel.textColor = .label
        }
    }
}

// MARK: - Helper Methods -
private extension PortfolioSummaryRowView {
    func setupUI() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 16)
        ])
    }
}
