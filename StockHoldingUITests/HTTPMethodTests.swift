//
//  HTTPMethodTests.swift
//  StockHoldingUITests
//
//  Created by Nitin Srivastav on 17/11/24.
//

import XCTest
@testable import StockHoldingUI

final class HTTPMethodTests: XCTestCase {

    func testHTTPMethodInitialization() {
            // Test each HTTP method
            let getMethod = HTTPMethod.get
            let postMethod = HTTPMethod.post
            let putMethod = HTTPMethod.put
            
            XCTAssertEqual(getMethod.rawValue, "GET")
            XCTAssertEqual(postMethod.rawValue, "POST")
            XCTAssertEqual(putMethod.rawValue, "PUT")
            
            // Test for equality
            XCTAssertEqual(HTTPMethod.get, HTTPMethod.get)
            XCTAssertNotEqual(HTTPMethod.get, HTTPMethod.post)
        }
        
        func testHTTPMethodHashable() {
            let methods: Set<HTTPMethod> = [HTTPMethod.get, HTTPMethod.post, HTTPMethod.put]
            
            XCTAssertTrue(methods.contains(HTTPMethod.get))
            XCTAssertTrue(methods.contains(HTTPMethod.post))
            XCTAssertTrue(methods.contains(HTTPMethod.put))
        }

}

class httpErrorTests: XCTestCase {
    
    func testhttpErrorCases() {
        // Test each case of the httpError enum
        let error1: httpError = .jsonDecoding
        let error2: httpError = .noData
        let error3: httpError = .nonSuccessStatusCode
        let error4: httpError = .serverError
        let error5: httpError = .emptyCollection
        let error6: httpError = .emptyObject
        let error7: httpError = .invalidUrl
        
        XCTAssertEqual(error1, .jsonDecoding)
        XCTAssertEqual(error2, .noData)
        XCTAssertEqual(error3, .nonSuccessStatusCode)
        XCTAssertEqual(error4, .serverError)
        XCTAssertEqual(error5, .emptyCollection)
        XCTAssertEqual(error6, .emptyObject)
        XCTAssertEqual(error7, .invalidUrl)
    }
}
