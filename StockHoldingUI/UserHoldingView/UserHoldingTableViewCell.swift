//
//  StockTableViewCell.swift
//  StockHoldingUI
//
//  Created by Nitin Srivastav on 15/11/24.
//

import UIKit

class UserHoldingTableViewCell: UITableViewCell {

    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var quantitylabel: UILabel!
    @IBOutlet weak var ltpLabel: UILabel!
    @IBOutlet weak var profitLossLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDataToCell(stock: Stock?) {
        if let stock = stock as? UserHolding {
            self.stockName.text = stock.symbol
            self.quantitylabel.text = stock.quantity.description
            self.ltpLabel.text = "₹"+stock.ltp.description
            self.profitLossLabel.formatRupeeString(from: stock.totalPNL())
        }
    }

}
