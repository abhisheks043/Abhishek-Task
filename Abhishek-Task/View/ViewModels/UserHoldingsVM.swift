//
//  UserHoldingsVM.swift
//  Abhishek-Task
//
//  Created by Abhishek on 14/11/25.
//

import Foundation
import UIKit

protocol UserHoldingsVMProtocol {
    var delegate: UserHoldingsVCDelegate? { get set }
    
    var holdingsCount: Int { get }
    func getUserHolding(for index: Int) -> Holding?
    
    var allHoldings: [Holding] { get }

    func loadUserHoldings()
}

class UserHoldingsVM {
    // MARK: - Properties -
    private let apiService: UserHoldingsAPIServiceProtocol
    
    private var holdingsResponse: HoldingsResponse?
    
    // delegate
    weak var delegate: UserHoldingsVCDelegate?
    
    // MARK: - Initialization -
    init(apiService: UserHoldingsAPIServiceProtocol = UserHoldingsAPIService()) {
        self.apiService = apiService
    }
}

//MARK: - UserHoldingsVMProtocol Properties & Methods -
extension UserHoldingsVM: UserHoldingsVMProtocol {
    var holdingsCount: Int {
        holdingsResponse?.data?.userHolding?.count ?? .zero
    }
    
    func getUserHolding(for index: Int) -> Holding? {
        guard index >= 0 && index < holdingsCount else { return nil }
        return holdingsResponse?.data?.userHolding?[index]
    }
    
    var allHoldings: [Holding] {
        return holdingsResponse?.data?.userHolding ?? []
    }
    
    func loadUserHoldings() {
        Task {
            do {
                let response = try await apiService.fetchHoldingsResponse()
                self.holdingsResponse = response
                
                // fire delegate back to viewController
                await MainActor.run {
                    self.delegate?.updateOnAPISuccess()
                }
            } catch {
                // fire failure delegate
                await MainActor.run {
                    self.delegate?.updateOnAPIFailure(with: error)
                }
            }
        }
    }
}
