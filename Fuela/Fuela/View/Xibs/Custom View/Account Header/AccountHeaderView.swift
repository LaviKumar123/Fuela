//
//  AccountHeaderView.swift
//  Fuela
//
//  Created by lavi on 12/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import SDWebImage
import GSKStretchyHeaderView

class AccountHeaderView: GSKStretchyHeaderView {
    
    //MARK:- Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let appUser = AppUser.shared {
            self.userNameLabel.text = appUser.fullName!
            self.userEmailLabel.text = appUser.email!
            
            if let url = URL(string: appUser.profileURL) {
                self.userImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .continueInBackground, completed: nil)
            }
        }
    }
    
    //MARK:- Button Action
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        SCENE_DELEGATE!.navigationController.pushViewController(vc, animated: true)
    }
}
