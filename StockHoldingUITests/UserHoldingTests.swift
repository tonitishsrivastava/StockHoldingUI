//
//  UserHoldingTests.swift
//  StockHoldingUITests
//
//  Created by Nitin Srivastav on 17/11/24.
//

import XCTest
@testable import StockHoldingUI

final class UserHoldingTests: XCTestCase {

    // Sample data for testing
       var userHoldings: [UserHolding]!
       var holdingData: HoldingData!
       
       override func setUp() {
           super.setUp()
           // Initialize sample user holdings
           userHoldings = [
               UserHolding(symbol: "AAPL", quantity: 10, ltp: 150, avgPrice: 120, close: 140),
               UserHolding(symbol: "GOOGL", quantity: 5, ltp: 2000, avgPrice: 1800, close: 1950),
               UserHolding(symbol: "AMZN", quantity: 2, ltp: 3000, avgPrice: 2500, close: 2900)
           ]
           
           // Initialize HoldingData with the sample holdings
           holdingData = HoldingData(userHolding: userHoldings)
       }
       
       override func tearDown() {
           userHoldings = nil
           holdingData = nil
           super.tearDown()
       }
       
       // MARK: - Tests for UserHolding Model
       
       func testUserHolding_getCurrentValue() {
           let aaplCurrentValue = userHoldings[0].getCurrentValue()
           XCTAssertEqual(aaplCurrentValue, 1500, "Current value for AAPL should be 1500")
           
           let googlCurrentValue = userHoldings[1].getCurrentValue()
           XCTAssertEqual(googlCurrentValue, 10000, "Current value for GOOGL should be 10000")
       }
       
       func testUserHolding_getTotalInvestment() {
           let aaplTotalInvestment = userHoldings[0].getTotalInvestment()
           XCTAssertEqual(aaplTotalInvestment, 1200, "Total investment for AAPL should be 1200")
           
           let googlTotalInvestment = userHoldings[1].getTotalInvestment()
           XCTAssertEqual(googlTotalInvestment, 9000, "Total investment for GOOGL should be 9000")
       }
       
       func testUserHolding_getTodaysPNL() {
           let aaplTodaysPNL = userHoldings[0].getTodaysPNL()
           XCTAssertEqual(aaplTodaysPNL, -100, "Today's PNL for AAPL should be -100")
           
           let googlTodaysPNL = userHoldings[1].getTodaysPNL()
           XCTAssertEqual(googlTodaysPNL, -250, "Today's PNL for GOOGL should be -250")
       }
       
       func testUserHolding_totalPNL() {
           let aaplTotalPNL = userHoldings[0].totalPNL()
           XCTAssertEqual(aaplTotalPNL, 300, "Total PNL for AAPL should be 300")
           
           let googlTotalPNL = userHoldings[1].totalPNL()
           XCTAssertEqual(googlTotalPNL, 1000, "Total PNL for GOOGL should be 1000")
       }
       
       // MARK: - Tests for HoldingData Model
       
       func testHoldingData_getTotalCurrentValue() {
           let totalCurrentValue = holdingData.getTotalCurrentValue()
           XCTAssertEqual(totalCurrentValue, 17500, "Total current value should be 17500")
       }
       
       func testHoldingData_getTotalInvestment() {
           let totalInvestment = holdingData.getTotalInvestment()
           XCTAssertEqual(totalInvestment, 15200, "Total investment should be 15200")
       }
       
       func testHoldingData_getTotalTodayPNL() {
           let totalTodayPNL = holdingData.getTotalTodayPNL()
           XCTAssertEqual(totalTodayPNL, -550, "Total today's PNL should be -550")
       }
       
       func testHoldingData_getTotalPNLValue() {
           let totalPNLValue = holdingData.getTotalPNLValue()
           XCTAssertEqual(totalPNLValue, 2300, "Total PNL value should be 2300")
       }

}
