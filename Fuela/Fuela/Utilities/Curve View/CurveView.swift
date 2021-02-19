//
//  CurveView.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import Foundation
import UIKit

class CurveView:UIView {

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
                withCenter: CGPoint(x:self.frame.width/2, y:self.frame.height/2),
                radius: 575 ,
                startAngle: start,
                endAngle: end,
                clockwise: true
            )
            let layer = CAShapeLayer()
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = UIColor.lightGray.cgColor
            layer.path = path.cgPath
            self.layer.addSublayer(layer)
        }

    }

}
