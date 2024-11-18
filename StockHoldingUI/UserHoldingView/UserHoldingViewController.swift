//
//  ViewController.swift
//  StockHoldingUI
//
//  Created by Nitin Srivastav on 15/11/24.
//

import UIKit

class UserHoldingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cardHeight: NSLayoutConstraint!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var totalInvestmentLabel: UILabel!
    @IBOutlet weak var todaysPNLLabel: UILabel!
    @IBOutlet weak var pNLLabel: UILabel!
    @IBOutlet weak var bottomCardView: UIView!
    
    
    var isViewCollapsed = true
    
    let stockViewModal = UserHoldingViewModel.shared
    
    var userHoldings: [UserHolding] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stockViewModal.stockDataSource = self
        self.stockViewModal.getData()
        self.tableView.register(UINib(nibName: UserHoldingTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: UserHoldingTableViewCell.reuseIdentifier)
        self.bottomCardView.makeTopCornersRounded(radius: 8)
        self.addBottomSpaceToTableView(space: 56)
        self.activityIndicator.startAnimating()
        
    }
    
    @IBAction func expandButtonAction(_ sender: UIButton) {
        if self.isViewCollapsed {
            UIView.animate(withDuration: 0.6) {
                self.cardHeight.constant = 156
                self.view.layoutIfNeeded()
                self.addBottomSpaceToTableView(space: 212)
                self.arrowImageView.image = UIImage(systemName: "chevron.down")
            }
        } else {
            UIView.animate(withDuration: 0.6) {
                self.cardHeight.constant = 0
                self.view.layoutIfNeeded()
                self.addBottomSpaceToTableView(space: 56)
                self.arrowImageView.image = UIImage(systemName: "chevron.up")
            }
        }
        self.isViewCollapsed.toggle()
    }
    
    func addBottomSpaceToTableView(space: CGFloat) {
        tableView.contentInset = UIEdgeInsets(top: self.tableView.contentInset.top,
                                              left: self.tableView.contentInset.left,
                                              bottom: space,
                                              right: self.tableView.contentInset.right)
    }
    
}

extension UserHoldingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userHoldings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserHoldingTableViewCell.reuseIdentifier, for: indexPath) as? UserHoldingTableViewCell
        cell?.setDataToCell(stock: stockViewModal.fetchStock(at: indexPath.row))
        return cell!
    }
    
    
}

extension UserHoldingViewController: StockDataSource {
    
    func isUserHoldingDataAvailable(holdingData: HoldingData) {
        DispatchQueue.main.async {
            self.currentValueLabel.text = "₹"+String(format: "%.2f", holdingData.getTotalCurrentValue())
            self.totalInvestmentLabel.text = "₹"+String(format: "%.2f", holdingData.getTotalInvestment())
            self.todaysPNLLabel.formatRupeeString(from: holdingData.getTotalTodayPNL())
            self.pNLLabel.formatRupeeString(from: holdingData.getTotalPNLValue())
        }
    }
    
    func isAPIFailed(error: Error) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.presentDefaultErrorAlert(title: nil, error: error as? APIError)
        }
    }
    
    func isDataAvailable(userHoldings: [UserHolding]) {
        self.userHoldings = userHoldings
    }
}
