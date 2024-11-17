//
//  UserHoldingViewModelTests.swift
//  StockHoldingUITests
//
//  Created by Nitin Srivastav on 17/11/24.
//

import XCTest
@testable import StockHoldingUI

class MockUserHoldingAPI: UserHoldingAPIProtocol {
    static let shared = MockUserHoldingAPI()
    var shouldFail = false
    var errorToThrow: Error?
    var mockResponse: UserHoldingResponse?
    
    func getStockList() async -> Result<UserHoldingResponse, Error> {
        if shouldFail {
            return .failure(errorToThrow ?? NSError(domain: "MockError", code: 500, userInfo: nil))
        } else if let response = mockResponse {
            return .success(response)
        } else {
            return .failure(NSError(domain: "NoData", code: 404, userInfo: nil))
        }
    }
}

class MockStockDataSource: StockDataSource {
    var isDataAvailableCalled = false
    var isAPIFailedCalled = false
    var receivedUserHoldings: [UserHolding] = []
    
    func isDataAvailable(userHoldings: [UserHolding]) {
        isDataAvailableCalled = true
        receivedUserHoldings = userHoldings
    }
    
    func isUserHoldingDataAvailable(holdingData: HoldingData) {
    }
    
    func isAPIFailed(error: Error) {
        isAPIFailedCalled = true
    }
}

 class UserHoldingViewModelTests: XCTestCase {

     var viewModel: UserHoldingViewModel!
        var mockDataSource: MockStockDataSource!
        var mockAPI: MockUserHoldingAPI!
        
        override func setUp() {
            super.setUp()
            
            mockAPI = MockUserHoldingAPI.shared
            viewModel = UserHoldingViewModel(api: mockAPI)
            mockDataSource = MockStockDataSource()
            viewModel.stockDataSource = mockDataSource
        }
        
        override func tearDown() {
            viewModel = nil
            mockDataSource = nil
            mockAPI = nil
            super.tearDown()
        }
        
        func testFetchStock_Success() async {
            let userHoldings = [
                UserHolding(symbol: "AAPL", quantity: 10, ltp: 150, avgPrice: 120, close: 140),
                UserHolding(symbol: "GOOGL", quantity: 5, ltp: 2000, avgPrice: 1800, close: 1950)
            ]
            let mockResponse = UserHoldingResponse(data: HoldingData(userHolding: userHoldings))
            mockAPI.shouldFail = false
            mockAPI.mockResponse = mockResponse
            
            // Act
            await viewModel.fetchData()
            
            // Assert
            XCTAssertTrue(mockDataSource.isDataAvailableCalled, "Data source should be notified when data is available")
            XCTAssertEqual(mockDataSource.receivedUserHoldings.count, 2, "Should have received 2 holdings")
            
            // Test fetching a valid stock
            let holding = viewModel.fetchStock(at: 0)
            XCTAssertNotNil(holding, "Holding should not be nil for a valid index")
            XCTAssertEqual(holding?.symbol, "AAPL", "First holding should be AAPL")
            
            // Test fetching an invalid stock (out of bounds)
            let invalidHolding = viewModel.fetchStock(at: 10)
            XCTAssertNil(invalidHolding, "Holding should be nil for an invalid index")
        }
        
        func testFetchStock_Failure() async {
            // Set up mock API to fail
            let error = NSError(domain: "APIError", code: 500, userInfo: nil)
            mockAPI.shouldFail = true
            mockAPI.errorToThrow = error
            
            // Act
            await viewModel.fetchData()
            
            // Assert
            XCTAssertTrue(mockDataSource.isAPIFailedCalled, "Data source should be notified when API fails")
        }

}
