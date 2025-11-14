//
//  HoldingInfoView.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import UIKit

enum HoldingInfoType {
    case netQty
    case ltp
    case pnl
    
    var title: String {
        switch self {
        case .netQty:
            return "NET QTY:"
        case .ltp:
            return "LTP:"
        case .pnl:
            return "P&L:"
        }
    }
}

class HoldingInfoView: UIView {
    
    // MARK: - Properties -
    private let type: HoldingInfoType
    
    // MARK: - UI Components -
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }()
    
    // MARK: - Initialization -
    init(type: HoldingInfoType) {
        self.type = type
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration -
    func configure(with value: String, isPositive: Bool? = nil) {
        valueLabel.text = value
        
        // Apply color based on type and value
        switch type {
        case .pnl:
            if let isPositive = isPositive {
                valueLabel.textColor = isPositive ? .systemGreen : .systemRed
            } else {
                valueLabel.textColor = .label
            }
        case .netQty, .ltp:
            valueLabel.textColor = .label
        }
    }
}

// MARK: - Helper Methods -
private extension HoldingInfoView {
    func setupUI() {
        titleLabel.text = type.title
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

