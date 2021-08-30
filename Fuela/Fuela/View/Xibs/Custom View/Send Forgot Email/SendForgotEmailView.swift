//
//  SendForgotEmailView.swift
//  Fuela
//
//  Created by lavi on 12/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class SendForgotEmailView: UIView {

    //MARK:- Outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    //MARK:- Variables
    static var containerView: SendForgotEmailView!
    
    class func show(_ owner: UIViewController,title: String, message: String) {
        
        SendForgotEmailView.containerView =  UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SendForgotEmailView
        
        SendForgotEmailView.containerView.frame = owner.view.frame
        
        SendForgotEmailView.containerView.titleLabel.text = title
        SendForgotEmailView.containerView.messageLabel.text = message
        
        owner.view.addSubview(SendForgotEmailView.containerView)
        
        SendForgotEmailView.containerView.contentView.frame.origin.y = -SendForgotEmailView.containerView.contentView.frame.size.height
        SendForgotEmailView.containerView.contentView.center.x = SendForgotEmailView.containerView.center.x
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations:{
            
//            containerView.alpha = 0
            SendForgotEmailView.containerView.contentView.center = SendForgotEmailView.containerView.center
            
        }) { _ in
        }
    }
    
    //MARK:- Button Action
    @IBAction func backToLogin(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            
            SendForgotEmailView.containerView.alpha = 0
            SendForgotEmailView.containerView.contentView.frame.origin.y = SendForgotEmailView.containerView.frame.size.height + SendForgotEmailView.containerView.contentView.frame.size.height
        }) { _ in
            SendForgotEmailView.containerView.removeFromSuperview()
            SCENE_DELEGATE!.navigationController.popViewController(animated: true)
        }
    }
}
