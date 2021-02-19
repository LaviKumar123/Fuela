//
//  UIViewExtension.swift
//  Pods
//
//  Created by KeepWorks on 5/27/16.
//   © 2017 KeepWorks Technologies Pvt Ltd. All rights reserved.
//

import UIKit

extension UIView {
    func loadViewFromNib() {
        let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        let view = Bundle(for: type(of: self)).loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let views = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        setNeedsUpdateConstraints()
    }
    
    func addDashedBorder() {
        let color = UIColor.lightGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: frameSize.width/2).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
}
