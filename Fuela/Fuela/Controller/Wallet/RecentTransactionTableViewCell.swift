//
//  TransactionTableViewCell.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class RecentTransactionTableViewCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var transactionDescLabel: UILabel!
    @IBOutlet weak var transactionTimeLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var closingBalanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var transaction: Transaction! {
        didSet {
            self.transactionAmountLabel.text = transaction.transactionAmount
            self.transactionDescLabel.text   = transaction.transactionDescription
            self.closingBalanceLabel.text    = transaction.card_balance
            self.transactionTimeLabel.text   = transaction.transactionDate.convertDateFormat(currentFormat: "dd/MM/yyyy hh:mm:ss", newFormat: "hh:mm a")
            self.transactionDateLabel.text   = transaction.transactionDate.convertDateFormat(currentFormat: "dd/MM/yyyy HH:mm:ss", newFormat: "dd MMM yyyy")
        }
    }
}
