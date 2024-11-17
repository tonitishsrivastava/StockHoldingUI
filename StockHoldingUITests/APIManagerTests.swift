//
//  APIManagerTests.swift
//  StockHoldingUITests
//
//  Created by Nitin Srivastav on 17/11/24.
//

import XCTest
@testable import StockHoldingUI

final class APIManagerTests: XCTestCase {
    
    func testCreateURLRequest_validURL() {
        let urlString = "https://api.example.com"
        let token = "TestToken"
        let method = HTTPMethod.get
        let body: Data? = nil
        
        let result = APIManager.shared.createURLRequest(urlString: urlString, token: token, method: method, body: body)
        
        switch result {
        case .success(let request):
            XCTAssertEqual(request.url?.absoluteString, urlString)
            XCTAssertEqual(request.httpMethod, method.rawValue)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Authorization"), token)
            XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
        case .failure(let error):
            XCTFail("Expected URLRequest, but got error: \(error)")
        }
    }
    
    func testCreateURLRequest_invalidURL() {
        let urlString = ""
        let token = "TestToken"
        let method = HTTPMethod.get
        let body: Data? = nil
        
        let result = APIManager.shared.createURLRequest(urlString: urlString, token: token, method: method, body: body)
        
        switch result {
        case .success:
            XCTFail("Expected failure for invalid URL, but got success")
        case .failure(let error):
            XCTAssertEqual(error, httpError.invalidUrl, "Expected httpError.invalidUrl, but got \(error)")
        }
    }
    
    func testPerformOperation_success() async {
        // Mock a successful response
        let expectation = XCTestExpectation(description: "Expected a successful response")
        
        // Create a dummy request (use a valid URL in place of the example)
        let urlString = "https://35dee773a9ec441e9f38d5fc249406ce.api.mockbin.io/"
        let urlRequestResult = APIManager.shared.createURLRequest(urlString: urlString, token: nil, method: .get, body: nil)
        
        switch urlRequestResult {
        case .success(let request):
            let response: Result<UserHoldingResponse, Error> = await APIManager.shared.performOperation(request: request, response: UserHoldingResponse.self)
            
            switch response {
            case .success(let data):
                // Assuming `data` is a valid UserHoldingResponse, validate
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got error: \(error)")
            }
        case .failure(let error):
            XCTFail("Expected URLRequest, but got error: \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testPerformOperation_failure() async {
        // Mock a failed response (use an invalid URL or simulate server failure)
        let expectation = XCTestExpectation(description: "Expected failure response")
        
        let urlString = "invalid-url"
        let urlRequestResult = APIManager.shared.createURLRequest(urlString: urlString, token: nil, method: .get, body: nil)
        
        switch urlRequestResult {
        case .success(let request):
            let response: Result<UserHoldingResponse, Error> = await APIManager.shared.performOperation(request: request, response: UserHoldingResponse.self)
            
            switch response {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        case .failure(let error):
            XCTFail("Expected URLRequest, but got error: \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
}
