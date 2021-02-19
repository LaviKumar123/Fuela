//
//  FAQsTableViewCell.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class FAQsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var upDownIcon: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Variables
    var completion: ((String)->())!

    //MARK:- Button Action
    @IBAction func titleButtonTapped(_ sender: UIButton) {
        self.completion("")
    }
}
