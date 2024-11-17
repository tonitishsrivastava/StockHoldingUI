//
//  UserHoldingAPITests.swift
//  StockHoldingUITests
//
//  Created by Nitin Srivastav on 17/11/24.
//

import XCTest
@testable import StockHoldingUI


final class UserHoldingAPITests: XCTestCase {
    
    var mockAPI: MockUserHoldingAPI!
    
    override func setUp() {
        super.setUp()
        mockAPI = MockUserHoldingAPI()
    }
    
    override func tearDown() {
        mockAPI = nil
        super.tearDown()
    }
    
    // Test case for successful API response
    func testGetStockList_Success() async {
        // Create mock data
        let userHoldings = [
            UserHolding(symbol: "AAPL", quantity: 10, ltp: 150, avgPrice: 120, close: 140),
            UserHolding(symbol: "GOOGL", quantity: 5, ltp: 2000, avgPrice: 1800, close: 1950)
        ]
        let mockResponse = UserHoldingResponse(data: HoldingData(userHolding: userHoldings))
        
        // Set up the mock API to return a successful response
        mockAPI.shouldFail = false
        mockAPI.mockResponse = mockResponse
        
        // Call the method and check the response
        let result = await mockAPI.getStockList()
        
        switch result {
        case .success(let response):
            XCTAssertEqual(response.data.userHolding.count, 2, "The response should contain 2 holdings.")
            XCTAssertEqual(response.data.userHolding.first?.symbol, "AAPL", "The first holding symbol should be 'AAPL'.")
        case .failure:
            XCTFail("Expected success but got failure")
        }
    }
    
    // Test case for API failure
    func testGetStockList_Failure() async {
        // Set up the mock API to fail
        mockAPI.shouldFail = true
        mockAPI.errorToThrow = NSError(domain: "APIError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Internal Server Error"])
        
        // Call the method and check the response
        let result = await mockAPI.getStockList()
        
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            let nsError = error as NSError
            XCTAssertEqual(nsError.code, 500, "Error code should be 500.")
            XCTAssertEqual(nsError.localizedDescription, "Internal Server Error", "Error message should match.")
        }
    }
    
}
