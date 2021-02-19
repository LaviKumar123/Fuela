//
//  AccountVerificationViewController.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class AccountVerificationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func underReviewButtonTapped(_ sender: UIButton) {
        let vc = ACCOUNT_STORYBOARD.instantiateViewController(identifier: "QuotationViewController") as! QuotationViewController
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
