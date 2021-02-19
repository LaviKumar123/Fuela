//
//  FuelaPayViewController.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.amountTextField.becomeFirstResponder()
    }
    
    //MARK:- Button Action
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        Indicator.shared.startAnimating(self.view)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            Indicator.shared.stopAnimating()
            PaidSuccessView.show(self, message: "Password Changed Successfully.")
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
                Indicator.shared.stopAnimating()
                timer.invalidate()
                
                let viewControllers = self.navigationController!.viewControllers as [UIViewController]
                for aViewController:UIViewController in viewControllers {
                    if aViewController.isKind(of: TabBarViewController.self) {
                        _ = self.navigationController?.popToViewController(aViewController, animated: true)
                    }
                }
            }
        }
    }
}
