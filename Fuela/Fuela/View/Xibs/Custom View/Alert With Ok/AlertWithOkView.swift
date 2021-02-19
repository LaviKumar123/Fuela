//
//  AlertWithOkView.swift
//  Fuela
//
//  Created by lavi on 20/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import Foundation
import UIKit

class AlertWithOkView: UIView {

    //MARK:- Outlet
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    static var containerView: AlertWithOkView!
    
    static var completion: ((String)->())!
    
    class func show(_ owner: UIViewController,image: UIImage, message: String) {
        
        AlertWithOkView.containerView =  UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AlertWithOkView
        
        AlertWithOkView.containerView.frame = owner.view.frame
        
        owner.view.addSubview(AlertWithOkView.containerView)
        
        AlertWithOkView.containerView.messageLabel.text = message
        AlertWithOkView.containerView.iconView.image = image
        
        AlertWithOkView.containerView.contentView.frame.origin.y = -AlertWithOkView.containerView.contentView.frame.size.height
        AlertWithOkView.containerView.contentView.center.x = AlertWithOkView.containerView.center.x
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations:{
            
//            containerView.alpha = 0
            AlertWithOkView.containerView.contentView.center = AlertWithOkView.containerView.center
            
        }) { _ in
            
        }
    }
    
    //MARK:- Button Action
    @IBAction func okButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            
            AlertWithOkView.containerView.alpha = 0
            AlertWithOkView.containerView.contentView.frame.origin.y = AlertWithOkView.containerView.frame.size.height + AlertWithOkView.containerView.contentView.frame.size.height
            
        }) { _ in
            AlertWithOkView.completion("Ok")
            AlertWithOkView.containerView.removeFromSuperview()
        }
    }
}
