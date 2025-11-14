//
//  HoldingTableViewCell.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import UIKit

class HoldingTableViewCell: UITableViewCell {
    
    // MARK: - Constants -
    static let reuseIdentifier = "HoldingTableViewCell"
    
    // MARK: - UI Components - 
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let netQtyView = HoldingInfoView(type: .netQty)
    private let ltpView = HoldingInfoView(type: .ltp)
    private let pnlView = HoldingInfoView(type: .pnl)
    
    private let leftStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 24
        return stack
    }()
    
    private let rightStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.spacing = 24
        return stack
    }()
    
    private let spacerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .top
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    // MARK: - Initialization -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with holding: Holding) {
        symbolLabel.text = holding.symbol
        
        // Net QTY
        netQtyView.configure(with: "\(holding.quantity)")
        
        // LTP
        ltpView.configure(with: holding.ltp.formattedPrice())
        
        // P&L
        let pnlText = holding.pnl >= 0 
            ? holding.pnl.formattedPrice() 
            : "-\(abs(holding.pnl).formattedPrice())"
        pnlView.configure(with: pnlText, isPositive: holding.pnl >= 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        symbolLabel.text = ""
        netQtyView.configure(with: "")
        ltpView.configure(with: "")
        pnlView.configure(with: "")
    }
}

// MARK: - Helper Methods -
private extension HoldingTableViewCell {
    func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        contentView.addSubview(separatorView)
        
        containerView.addSubview(mainStackView)
        
        // Configure left stack (symbol + net qty)
        leftStackView.addArrangedSubview(symbolLabel)
        leftStackView.addArrangedSubview(netQtyView)
        
        // Configure right stack (LTP + P&L)
        rightStackView.addArrangedSubview(ltpView)
        rightStackView.addArrangedSubview(pnlView)
        
        // Configure main horizontal stack (left + spacer + right)
        mainStackView.addArrangedSubview(leftStackView)
        mainStackView.addArrangedSubview(spacerView)
        mainStackView.addArrangedSubview(rightStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            mainStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
