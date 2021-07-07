//
//  SuccessAlertView.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class AlertView: UIView {

    //MARK:- Outlet
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    class func show(_ owner: UIViewController,image: UIImage, message: String) {
        
        let containerView =  UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AlertView
        
        containerView.frame = owner.view.frame
        
        owner.view.addSubview(containerView)
        
        containerView.messageLabel.text = message
        containerView.iconView.image = image
        
        containerView.contentView.frame.origin.y = -containerView.contentView.frame.size.height
        containerView.contentView.center.x = containerView.center.x
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations:{
            
            //            containerView.alpha = 0
            containerView.contentView.center = containerView.center
            
        }) { _ in
            
            
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseIn, animations: {
                
                containerView.alpha = 0
                
            }) { _ in
                containerView.removeFromSuperview()
            }
        }
    }
}
