//
//  FuelaPayViewController.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import FloatingPanel

class FuelaPayViewController: UIViewController {
    
    //MARK:- Variables
    var fpc: FloatingPanelController!

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.floatingPanelSetup()
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func scanButtonTapped(_ sender: UIButton) {
    }
    
    //MARK:- Bottom FloatingPanel Setup
    func floatingPanelSetup() {
        self.fpc = FloatingPanelController()
        let contentVC = HOME_STORYBOARD.instantiateViewController(withIdentifier: "RecentFuelaPayViewController") as! RecentFuelaPayViewController
        self.fpc.set(contentViewController: contentVC)
        self.fpc.addPanel(toParent: self)
        self.fpc.view.cornerRadius = 20
        self.fpc.view.masksToBounds = true
        
        self.fpc.delegate = self
    }
}

extension FuelaPayViewController : FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return MyFloatingPanelLayout()
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .half
    }

    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
            case .full: return 16.0 // A top inset from safe area
            case .half: return UIScreen.main.bounds.height - 300// A bottom inset from the safe area
            case .tip: return 44.0 // A bottom inset from the safe area
            default: return nil // Or `case .hidden: return nil`
        }
    }
}
