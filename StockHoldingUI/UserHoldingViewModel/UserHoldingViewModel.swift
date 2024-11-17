//
//  StockViewModel.swift
//  StockHoldingUI
//
//  Created by Nitin Srivastav on 16/11/24.
//

import Foundation
import UIKit

class UserHoldingViewModel {
    
    static let shared = UserHoldingViewModel()
    private var userHoldings: [UserHolding] = []
    
    var stockDataSource: StockDataSource?
    private let api: UserHoldingAPIProtocol
    
    // Dependency injection via initializer
    init(api: UserHoldingAPIProtocol = UserHoldingAPI.shared) {
        self.api = api
        self.getData()
    }
    
    func getData() {
        Task {
            await fetchData()
        }
    }
    
    /// Fetches user holding data.
    func fetchData() async {
        let response = await api.getStockList()
        switch response {
        case .success(let stockResponse):
            self.userHoldings = stockResponse.data.userHolding
            self.stockDataSource?.isDataAvailable(userHoldings: self.userHoldings)
            self.stockDataSource?.isUserHoldingDataAvailable(holdingData: stockResponse.data)
        case .failure(let error):
            self.stockDataSource?.isAPIFailed(error: error)
        }
    }
    
    /// Fetches the holding data at a specific index.
    func fetchStock(at index: Int) -> UserHolding? {
        guard index < userHoldings.count else { return nil }
        return userHoldings[index]
    }
    
}

protocol StockDataSource {
    func isDataAvailable(userHoldings: [UserHolding])
    func isAPIFailed(error: Error)
    func isUserHoldingDataAvailable(holdingData: HoldingData)
}
