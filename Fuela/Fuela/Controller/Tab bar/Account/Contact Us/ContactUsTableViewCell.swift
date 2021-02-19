//
//  ContactTableViewCell.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class ContactUsTableViewCell: UITableViewCell {
    
    //MARK:- Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
