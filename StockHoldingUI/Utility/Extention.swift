//
//  Extention.swift
//  StockHoldingUI
//
//  Created by Nitin Srivastav on 17/11/24.
//

import Foundation
import UIKit

extension UILabel {
    func formatRupeeString(from value: Double) {
        let rupeeSymbol = "₹"
        
        if value < 0 {
            // If the value is negative, prepend the minus sign
            self.textColor = UIColor.red
            self.text = "-\(rupeeSymbol)"+String(format: "%.2f", abs(value))
        } else {
            // If the value is positive, just add the rupee symbol
            self.textColor = UIColor(red: 24/255, green: 99/255, blue: 30/255, alpha: 1)
            self.text = "\(rupeeSymbol)"+String(format: "%.2f", abs(value))
        }
    }
}

extension UIView {
    
    func makeTopCornersRounded(radius: CGFloat) {
        // Set the corner radius
        self.layer.cornerRadius = radius
        
        // Mask only the top-left and top-right corners
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Enable clipping to bounds to apply the corner radius
        self.clipsToBounds = true
    }
    
}

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
}
