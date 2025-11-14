//
//  PortfolioSummaryView.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import UIKit

protocol PortfolioSummaryViewDelegate: AnyObject {
    func didToggleExpandCollapse()
}

class PortfolioSummaryView: UIView {
    
    // MARK: - Properties -
    weak var delegate: PortfolioSummaryViewDelegate?
    private var isExpanded = false
    
    // MARK: - UI Components -
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    private let topBorderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.separator
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Profit & Loss*"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.up")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let totalPNLLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let expandableContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        return stack
    }()
    
    private let currentValueRow = PortfolioSummaryRowView()
    private let totalInvestmentRow = PortfolioSummaryRowView()
    private let todaysPNLRow = PortfolioSummaryRowView()
    
    private let heightConstraint: NSLayoutConstraint
    
    // MARK: - Initialization -
    override init(frame: CGRect) {
        heightConstraint = expandableContentView.heightAnchor.constraint(equalToConstant: 0)
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        heightConstraint = NSLayoutConstraint()
        super.init(coder: coder)
    }
    
    // MARK: - Layout -
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure corner radius is applied
        containerView.layer.cornerRadius = 8
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Update top border mask with corner radius
        if topBorderView.bounds.width > 0 {
            let path = UIBezierPath(
                roundedRect: topBorderView.bounds,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: 8, height: 8)
            )
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            topBorderView.layer.mask = maskLayer
        }
    }
    
    // MARK: - Configuration -
    func configure(with summary: PortfolioSummary) {
        // Current value
        currentValueRow.configure(title: "Current value*", value: summary.currentValue.formattedPrice())
        
        // Total investment
        totalInvestmentRow.configure(title: "Total investment*", value: summary.totalInvestment.formattedPrice())
        
        // Today's PNL
        let todaysPNLText = summary.todaysPNL >= 0 
            ? summary.todaysPNL.formattedPrice() 
            : "-\(abs(summary.todaysPNL).formattedPrice())"
        todaysPNLRow.configure(title: "Today's Profit & Loss*", value: todaysPNLText, isPositive: summary.todaysPNL >= 0)
        
        // Total PNL (in header)
        let totalPNLPercentageFormatted = String(format: "%.2f", summary.totalPNLPercentage)
        let totalPNLText = summary.totalPNL >= 0 
            ? "\(summary.totalPNL.formattedPrice()) (\(totalPNLPercentageFormatted)%)"
            : "-\(abs(summary.totalPNL).formattedPrice()) (\(totalPNLPercentageFormatted)%)"
        totalPNLLabel.text = totalPNLText
        totalPNLLabel.textColor = summary.totalPNL >= 0 ? .systemGreen : .systemRed
    }
    
    @objc func headerTapped() {
        toggleExpandCollapse()
    }
}

// MARK: - Helper Methods -
private extension PortfolioSummaryView {
    func setupUI() {
        func setupExpandableContentView() {
            expandableContentView.addSubview(separatorView)
            expandableContentView.addSubview(contentStackView)
            
            contentStackView.addArrangedSubview(currentValueRow)
            contentStackView.addArrangedSubview(totalInvestmentRow)
            contentStackView.addArrangedSubview(todaysPNLRow)

            NSLayoutConstraint.activate([
                expandableContentView.topAnchor.constraint(equalTo: containerView.topAnchor),
                expandableContentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                expandableContentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                heightConstraint,
                
                // Separator view inside expandable content
                separatorView.bottomAnchor.constraint(equalTo: expandableContentView.bottomAnchor),
                separatorView.leadingAnchor.constraint(equalTo: expandableContentView.leadingAnchor, constant: 8),
                separatorView.trailingAnchor.constraint(equalTo: expandableContentView.trailingAnchor, constant: -8),
                separatorView.heightAnchor.constraint(equalToConstant: 0.5),
                
                // Content stack view
                contentStackView.topAnchor.constraint(equalTo: expandableContentView.topAnchor, constant: 16),
                contentStackView.leadingAnchor.constraint(equalTo: expandableContentView.leadingAnchor, constant: 16),
                contentStackView.trailingAnchor.constraint(equalTo: expandableContentView.trailingAnchor, constant: -16),
                contentStackView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -16)
            ])
        }
        
        func setupTopBorder() {
            containerView.addSubview(topBorderView)
            NSLayoutConstraint.activate([
                topBorderView.topAnchor.constraint(equalTo: containerView.topAnchor),
                topBorderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                topBorderView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                topBorderView.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        }
        
        func setupHeaderView() {
            headerView.addSubview(titleLabel)
            headerView.addSubview(chevronImageView)
            headerView.addSubview(totalPNLLabel)
            
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: expandableContentView.bottomAnchor, constant: 4),
                headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
                headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
                headerView.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
                headerView.heightAnchor.constraint(equalToConstant: 44),
                
                // Title label
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                
                // Chevron
                chevronImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
                chevronImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                chevronImageView.widthAnchor.constraint(equalToConstant: 16),
                chevronImageView.heightAnchor.constraint(equalToConstant: 16),
                
                // Total PNL label
                totalPNLLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                totalPNLLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
            //TODO: Add tap gesture to header
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped))
            headerView.addGestureRecognizer(tapGesture)
            headerView.isUserInteractionEnabled = true
        }

        
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(expandableContentView)
        
        // Set initial chevron state (collapsed - pointing down)
        chevronImageView.transform = CGAffineTransform(rotationAngle: .pi)
        
        NSLayoutConstraint.activate([
            // Container view
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        setupExpandableContentView()
        setupTopBorder()
        setupHeaderView()
    }
    
    
    func toggleExpandCollapse() {
        isExpanded.toggle()
        delegate?.didToggleExpandCollapse()
        
        // Calculate the actual content height
        let targetHeight: CGFloat
        if isExpanded {
            // Force layout to get accurate size
            contentStackView.setNeedsLayout()
            contentStackView.layoutIfNeeded()
            let contentHeight = contentStackView.systemLayoutSizeFitting(
                CGSize(width: contentStackView.bounds.width, height: UIView.layoutFittingCompressedSize.height),
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            ).height
            targetHeight = contentHeight + 32 // padding
        } else {
            targetHeight = 0
        }
        
        let rotationAngle: CGFloat = isExpanded ? 0 : .pi
        
        // animate changes
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: [.curveEaseInOut, .allowUserInteraction]) {
            self.heightConstraint.constant = targetHeight
            self.chevronImageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            self.superview?.layoutIfNeeded()
        }
    }
    
    // MARK: - Actions -
//    @objc func headerTapped() {
//        toggleExpandCollapse()
//    }
}

