//
//  RewardHeaderView.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class RewardHeaderView: GSKStretchyHeaderView {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var rewardAmountLabel: UILabel!
    
    
    var reward: Reward! {
        didSet {
            self.currencyLabel.text     = reward.currency
            self.rewardAmountLabel.text = reward.reward_amt
        }
    }
    
}
