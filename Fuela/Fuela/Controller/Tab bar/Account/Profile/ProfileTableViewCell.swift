//
//  ProfileTableViewCell.swift
//  Fuela
//
//  Created by lavi on 07/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    //MARK:- Outlet
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK:- Variable
    var completion: ((String)->())!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Button Action
    @IBAction func editButtonTapped(_ sender: UIButton) {
        self.completion(self.titleLabel.text!)
    }

}
