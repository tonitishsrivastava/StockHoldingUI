//
//  StockAPI.swift
//  StockHoldingUI
//
//  Created by Nitin Srivastav on 16/11/24.
//

import Foundation

protocol UserHoldingAPIProtocol {
    func getStockList() async -> Result<UserHoldingResponse, Error>
}

struct UserHoldingAPI: UserHoldingAPIProtocol {
    static let shared = UserHoldingAPI()
    
    private init() {}
    
    func getStockList() async -> Result<UserHoldingResponse, Error> {
        let urlRequestResult = createUrlRequestForGetStockList()
        switch urlRequestResult {
        case .success(let urlRequest):
            let serviceResponse = await APIManager.shared.performOperation(request: urlRequest, response: UserHoldingResponse.self)
            return serviceResponse
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func createUrlRequestForGetStockList() -> Result<URLRequest,httpError> {
        let urlString = AppConstant.PORTFOLIO_URL
        return APIManager.shared.createURLRequest(urlString: urlString, token: nil, method: .get, body: nil)
    }
}
