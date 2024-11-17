//
//  Stock.swift
//  StockHoldingUI
//
//  Created by Nitin Srivastav on 16/11/24.
//

import Foundation

// MARK: - Main Response
struct UserHoldingResponse: Codable {
    let data: HoldingData
}

// MARK: - Data Object
struct HoldingData: Codable {
    let userHolding: [UserHolding]
    
    func getTotalCurrentValue() -> Double {
        var totalCurrentValue = 0.0
        for hold in userHolding {
            totalCurrentValue += hold.getCurrentValue()
        }
        return totalCurrentValue
    }
    
    func getTotalInvestment() -> Double {
        var totalInvestmentValue = 0.0
        for hold in userHolding {
            totalInvestmentValue += hold.getTotalInvestment()
        }
        return totalInvestmentValue
    }
    
    func getTotalTodayPNL() -> Double {
        var totalTodayPNLValue = 0.0
        for hold in userHolding {
            totalTodayPNLValue += hold.getTodaysPNL()
        }
        return totalTodayPNLValue
    }
    
    func getTotalPNLValue() -> Double {
        var totalPNLValue = 0.0
        for hold in userHolding {
            totalPNLValue += hold.totalPNL()
        }
        return totalPNLValue
    }
    
}

protocol Stock {}

// MARK: - User Holding Model
struct UserHolding: Codable, Stock {
    let symbol: String
    let quantity: Double
    let ltp: Double
    let avgPrice: Double
    let close: Double
    
    func getCurrentValue() -> Double {
        return self.ltp*self.quantity
    }
    
    func getTotalInvestment() -> Double {
        return avgPrice*quantity
    }
    
    func getTodaysPNL() -> Double {
        return ((close-ltp)*quantity)
    }
    
    func totalPNL() -> Double {
        return getCurrentValue() - getTotalInvestment()
    }
}
