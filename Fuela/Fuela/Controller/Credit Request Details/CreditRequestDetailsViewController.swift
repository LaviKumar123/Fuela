//
//  CreditRequestViewController.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class CreditRequestDetailsViewController: UIViewController {
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func editWorkDetailsButtonTapped(_ sender: UIButton) {
        let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier: "WorkDetailsViewController") as! WorkDetailsViewController
        vc.isForUpdate = true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    @IBAction func editIncomeDetailsButtonTapped(_ sender: UIButton) {
        let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier: "IncomeDetailsViewController") as! IncomeDetailsViewController
        vc.isForUpdate = true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func editBankingDetailsButtonTapped(_ sender: UIButton) {
        let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier: "BankingDetailsViewController") as! BankingDetailsViewController
        vc.isForUpdate = true
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func requestNowButtonTapped(_ sender: UIButton) {
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "CreditRequestViewController") as! CreditRequestViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
