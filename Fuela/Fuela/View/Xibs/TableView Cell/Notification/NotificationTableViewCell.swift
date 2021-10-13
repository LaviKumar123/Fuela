//
//  NotificationTableViewCell.swift
//  Fuela
//
//  Created by lavi on 07/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var notification: NotificationInfo! {
        didSet {
            self.nameLabel.text = notification.title
            self.descriptionLabel.text = notification.message
            
            self.userImageView.sd_setImage(with: URL(string: notification.image_url), placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .continueInBackground, completed: nil)
        }
    }
}
