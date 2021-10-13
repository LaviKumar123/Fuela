//
//  AccountVerificationViewController.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class AccountVerificationViewController: UIViewController {
    
    var isFromRegistration = false
    var isFromHome = false
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func underReviewButtonTapped(_ sender: UIButton) {
//        let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier: "QuotationViewController") as! QuotationViewController
//        self.navigationController!.pushViewController(vc, animated: true)
        if self.isFromRegistration {
            let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier:  "LoginViewController") as! LoginViewController
            self.navigationController?.setViewControllers([vc], animated: true)
        }else if self.isFromHome {
            self.navigationController?.popViewController(animated: false)
        }else {
            let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier:  "TabBarViewController") as! TabBarViewController
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
}
