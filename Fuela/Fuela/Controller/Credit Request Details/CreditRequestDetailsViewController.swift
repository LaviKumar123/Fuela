//
//  CreditRequestViewController.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class CreditRequestDetailsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var creditAmountTextField: UITextField!
    
    var creditAmount = ""
    var isFromMenu = false
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.getRequestDetaills()
        self.requestToGetCorrency { (currency) in
            self.currencyLabel.text = currency
        }
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        if self.isFromMenu {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: TabBarViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }else {
            self.navigationController!.popViewController(animated: true)
        }
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
        
        if self.creditAmountTextField.text!.isEmpty {
            self.showAlert(title: "Credit Request", message: "Please enter the credit amount.", completion: nil)
        }else {
            if self.creditAmount != "" {
                self.showAlertWith(yesBtnTitle: "PROCEED", noBtnTitle: "NO", title: "Your credit request has been already approved by the admin", message: "Please proceed if you want to make a new request.") { (isYes) in
                    if isYes {
                        self.requestToRequestNow()
                    }
                }
            }else {
                self.requestToRequestNow()
            }
        }
    }
}

//MARK:- APIs
extension CreditRequestDetailsViewController {
    func requestToGetCorrency(completion: @escaping((String)->Void)) {
//        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToGetType(URLConstant.getCurrencyDetail) { (response, isSuccess) in
            
//            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        if let currency = data["currency_symbol"] as? String {
                            completion(currency)
                        }
                    }
                }else {
                    let message = (response as! [String:Any])["Error"] as? String ?? ""
                    AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
    
    func getRequestDetaills(){
        let param = [
            "user_id"    : AppUser.shared.id!,
        ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.getCreditRequest, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        self.creditAmount = data["value"] as? String ?? ""
                        self.creditAmountTextField.text = self.creditAmount
                    }
                }else {
                    if let message = (response as! [String:Any])["Error"] as? String {
                        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                    }else if let error = (response as! [String:Any])["errors"] as? [String:Any],
                             let userIDError = error["user_id"] as? String{
                        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: userIDError)
                    }
                    
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
    
    func requestToRequestNow() {
        let param = [
            "user_id"    : AppUser.shared.id!,
            "credit_amt" : self.creditAmountTextField.text!
        ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.requestCredit, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    let message = (response as! [String:Any])["msg"] as? String ?? ""
                    AlertView.show(self, image: #imageLiteral(resourceName: "Account verification"), message: message)
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                        let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier:  "TabBarViewController") as! TabBarViewController
                        self.navigationController?.setViewControllers([vc], animated: false)
                    }
                }else {
                    if let message = (response as! [String:Any])["msg"] as? String {
                        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                    }else if let error = (response as! [String:Any])["errors"] as? [String:Any],
                             let userIDError = error["user_id"] as? String{
                        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: userIDError)
                    }
                    
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
}
