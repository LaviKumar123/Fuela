//
//  RewardsTableViewCell.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class RewardsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var reward: Reward! {
        didSet {
            self.titleLabel.text  = reward.title
            self.amountLabel.text = reward.currency + " " + reward.reward_request_amt
            self.dateLabel.text   = reward.reward_date
            
            self.userImageView.sd_setImage(with: URL(string: reward.image_url), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .continueInBackground, completed: nil)
            
            
        }
    }

}
