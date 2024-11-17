//
//  Reusable.swift
//  StockHoldingUI
//
//  Created by Nitin Srivastav on 16/11/24.
//

import Foundation
import UIKit


protocol Reusable: AnyObject{
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)

    }
}

extension UITableViewCell: Reusable {}

extension UIViewController: Reusable {
    
    func presentDefaultErrorAlert(title: String? = nil, error: APIError?, actionHandler: ((Any)->())? = nil) {
        let alert = UIAlertController(title: title, message: error?.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: actionHandler)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
