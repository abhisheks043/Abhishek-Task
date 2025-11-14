//
//  UserHoldingsVC.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import Foundation
import UIKit

protocol UserHoldingsVCDelegate: AnyObject {
    func updateOnAPISuccess()
    func updateOnAPIFailure(with error: Error)
}

class UserHoldingsVC: BaseViewController {
    
    // MARK: - Instance Method -
    static func getInstance() -> UserHoldingsVC {
        let viewModel = UserHoldingsVM()
        let viewController = UserHoldingsVC(viewModel: viewModel)
        viewModel.delegate = viewController
        return viewController
    }
    
    // MARK: - UI Components -
    private let tableView = UITableView()
    private let portfolioSummaryView = PortfolioSummaryView()

    
    // MARK: - Properties -
    private let viewModel: UserHoldingsVMProtocol
    private let portfolioSummaryVM = PortfolioSummaryVM()
    private var portFolioHeightConstraint: NSLayoutConstraint
    
    // MARK: - Life Cycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            loadingState = .loading
        }
        setupUI()
        makeApiCall()
    }

    // MARK: - Initialization -
    private init(viewModel: UserHoldingsVMProtocol) {
        self.viewModel = viewModel
        self.portFolioHeightConstraint = NSLayoutConstraint()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overidden Methods -
    override func onStateChange(to state: LoadingState) {
        super.onStateChange(to: state)
        
        // update summaryview visibility
        switch state {
        case .loaded:
            portfolioSummaryView.isHidden = false
        default:
            portfolioSummaryView.isHidden = true
        }
    }
}

// MARK: - Helper Methods -
private extension UserHoldingsVC {
    func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        view.addSubview(tableView)
        view.addSubview(portfolioSummaryView)
        setupTableView()
        setupPortfolioSummaryView()
    }
    
    func setupPortfolioSummaryView() {
        portfolioSummaryView.translatesAutoresizingMaskIntoConstraints = false
        portfolioSummaryView.delegate = self
                
        NSLayoutConstraint.activate([
            portfolioSummaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            portfolioSummaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            portfolioSummaryView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: portfolioSummaryView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HoldingTableViewCell.self, forCellReuseIdentifier: HoldingTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.contentInset.bottom = 20
    }
    
    func makeApiCall() {
        viewModel.loadUserHoldings()
    }
    
    func updatePortfolioSummary() {
        let holdings = viewModel.allHoldings
        portfolioSummaryVM.calculateSummary(from: holdings)
        
        if let summary = portfolioSummaryVM.summary {
            portfolioSummaryView.configure(with: summary)
        }
    }
}

// MARK: - UserHoldingsVCDelegate Methods -
extension UserHoldingsVC: UserHoldingsVCDelegate {
    func updateOnAPISuccess() {
        tableView.reloadData()
        Task {
            loadingState = .loaded
            updatePortfolioSummary()
        }
        
    }
    
    func updateOnAPIFailure(with error: any Error) {
        loadingState = .error(error)
    }
}

// MARK: - PortfolioSummaryViewDelegate Methods -
extension UserHoldingsVC: PortfolioSummaryViewDelegate {
    func didToggleExpandCollapse() {
        //TODO: handle vc updation on toggle if needed
    }
}

// MARK: - TableView Delegate & DataSource Methods -
extension UserHoldingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.holdingsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let holding = viewModel.getUserHolding(for: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: HoldingTableViewCell.reuseIdentifier, for: indexPath) as? HoldingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: holding)
        return cell
    }
}
