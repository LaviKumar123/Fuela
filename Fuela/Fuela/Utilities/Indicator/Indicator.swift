//
//  Indicator.swift
//  TowBoss
//
//  Created by lavi on 26/12/19.
//  Copyright © 2019 lavi. All rights reserved.
//

import Foundation
import UIKit
import TransitionButton

class Indicator {

    var containerView      = UIView()
    var indicatorView      = UIView()
    var activityIndicator  = UIActivityIndicatorView()
    var transitionButton   = TransitionButton()

    open class var shared : Indicator {
        struct Static {
            static let instance: Indicator = Indicator()
        }
        return Static.instance
    }

    open func startAnimating(_ view : UIView) {
        containerView.frame           = view.frame
        containerView.center          = view.center
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)

        indicatorView.frame              = CGRect(x: 0, y: 0, width: 60, height: 60)
        indicatorView.center             = view.center
        indicatorView.backgroundColor    = UIColor(red: 208/255, green: 54/255, blue: 44/255, alpha: 1.0)
        indicatorView.clipsToBounds      = true
        indicatorView.layer.cornerRadius = 30

//        activityIndicator.frame          = CGRect(x: 0, y: 0, width: 40, height: 40)
//        activityIndicator.center         = CGPoint(x: indicatorView.bounds.width / 2, y: indicatorView.bounds.height / 2)
//        activityIndicator.style = .whiteLarge

        transitionButton.frame          = CGRect(x: 0, y: 0, width: 60, height: 60)
        transitionButton.center         = CGPoint(x: indicatorView.bounds.width / 2, y: indicatorView.bounds.height / 2)

        transitionButton.startAnimation()

        indicatorView.addSubview(transitionButton)
        containerView.addSubview(indicatorView)
        view.addSubview(containerView)

        view.endEditing(true)
        activityIndicator.startAnimating()
    }

    open func stopAnimating() {
//        activityIndicator.stopAnimating()
        //        indicator.stopAnimating()
        transitionButton.startAnimation()
        containerView.removeFromSuperview()
    }
}

extension UIColor {

    convenience init(hex: UInt32, alpha: CGFloat) {
        let red   = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue  = CGFloat(hex & 0xFF)/256.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
