//
//  OptionAlertView.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class OptionAlertView: UIView {
    
    //MARK:- Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    //MARK:- Variables
    static var containerView: OptionAlertView!
    var completionBlock : ((String)->())!
    
    //MARK:- Button Action
    @IBAction func noButtonTapped(_ sender: UIButton) {
        self.removeFromContainerView("No")
    }
    @IBAction func yesButtonTapped(_ sender: UIButton) {
        self.removeFromContainerView("Yes")
    }
    
    class func show(_ owner: UIViewController, title: String, message: String, completion: @escaping (String)->Void) {
            
           OptionAlertView.containerView =  UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! OptionAlertView
            
            OptionAlertView.containerView.frame = owner.view.frame
            
            owner.view.addSubview(containerView)
        
            OptionAlertView.containerView.titleLabel.text = title
            OptionAlertView.containerView.messageLabel.text = message
            
            OptionAlertView.containerView.contentView.frame.origin.y = -containerView.contentView.frame.size.height
            OptionAlertView.containerView.contentView.center.x = containerView.center.x
        
            OptionAlertView.containerView.completionBlock = { (action) in
                completion(action)
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations:{
                
    //            containerView.alpha = 0
                containerView.contentView.center = containerView.center
                
            }) { _ in
                
            }
        }
    
    func removeFromContainerView(_ action: String) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {

            OptionAlertView.containerView.contentView.frame.origin.y = OptionAlertView.containerView.frame.size.height + OptionAlertView.containerView.contentView.frame.size.height
            
            OptionAlertView.containerView.alpha = 0
        }) { _ in
            OptionAlertView.containerView.completionBlock(action)
            OptionAlertView.containerView.removeFromSuperview()
        }
    }
}
