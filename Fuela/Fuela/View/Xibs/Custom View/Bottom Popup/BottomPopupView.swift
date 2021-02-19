//
//  BottomPopupView.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class BottomPopupView: UIView {
    
    @IBOutlet weak var contentView: UIView!

    static var containerView : BottomPopupView!
    
    var once = true

    override func layoutSubviews() {
        super.layoutSubviews()

        if once {
            
            let pi = CGFloat(Float.pi)
            let start:CGFloat = 0.0
            let end :CGFloat = pi

            // circlecurve
            let path: UIBezierPath = UIBezierPath();
            path.addArc(
                withCenter: CGPoint(x:self.contentView.frame.width/2, y:self.contentView.frame.height + 70),
                radius: 300 ,
                startAngle: start,
                endAngle: end,
                clockwise: false
            )
            let layer = CAShapeLayer()
            layer.fillColor = UIColor(red: 216/255, green: 59/255, blue: 23/255, alpha: 1.0).cgColor
            layer.path = path.cgPath
            self.contentView.layer.addSublayer(layer)
        }
    }
    
    class func show(_ owner: UIViewController) {
            
            self.containerView =  UINib(nibName: "\(self)", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? BottomPopupView
            
            self.containerView.frame = owner.view.frame
            
            owner.view.addSubview(self.containerView)
            
            self.containerView.contentView.frame.origin.y = self.containerView.frame.size.height + self.containerView.contentView.frame.size.height
            
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {

                self.containerView.contentView.frame.origin.y = self.containerView.frame.size.height - self.containerView.contentView.frame.size.height

            }) { _ in

            }
        }
    
    //MARK:- Button Action
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {

            BottomPopupView.containerView.contentView.frame.origin.y = BottomPopupView.containerView.frame.size.height + BottomPopupView.containerView.contentView.frame.size.height

        }) { _ in
            BottomPopupView.containerView.alpha = 0
            BottomPopupView.containerView.removeFromSuperview()
        }
    }
    
    @IBAction func scanAndPayButtonTapped(_ sender: UIButton) {
        self.cancelButtonTapped(sender)
        let vc = HOME_STORYBOARD.instantiateViewController(identifier: "FuelaPayViewController") as! FuelaPayViewController
        SCENE_DELEGATE!.navigationController.pushViewController(vc, animated: true)
    }
    
    @IBAction func myRequestButtonTapped(_ sender: UIButton) {
        self.cancelButtonTapped(sender)
        let vc = HOME_STORYBOARD.instantiateViewController(identifier: "RequestReceivedViewController") as! RequestReceivedViewController
        SCENE_DELEGATE!.navigationController.pushViewController(vc, animated: true)
    }
}


