//
//  TransactionTableViewCell.swift
//  Fuela
//
//  Created by lavi on 07/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var userImageView  : UIImageView!
    @IBOutlet weak var userNameLabel  : UILabel!
    @IBOutlet weak var dateLabeL      : UILabel!
    @IBOutlet weak var amountLabel    : UILabel!
    @IBOutlet weak var statusLabel    : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
