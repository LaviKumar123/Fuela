//
//  PaidSuccessView.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class PaidSuccessView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    
    
    class func show(_ owner: UIViewController, message: String) {
        
        let containerView =  UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PaidSuccessView
        
        containerView.frame = owner.view.frame
        
        owner.view.addSubview(containerView)
        
        containerView.contentView.frame.origin.y = -containerView.contentView.frame.size.height
        containerView.contentView.center.x = containerView.center.x
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            
            //            containerView.alpha = 0
            containerView.contentView.center = containerView.center
            
        }) { _ in
            
            UIView.animate(withDuration: 1.0, delay: 2, options: .curveEaseIn, animations: {
                
                containerView.alpha = 0
                
            }) { _ in
                containerView.removeFromSuperview()
            }
        }
    }
}
