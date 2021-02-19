//
//  BankingDetailsViewController.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class BankingDetailsViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var bankHolderNameTextField: UITextField!
    @IBOutlet weak var bankNameTextField      : UITextField!
    @IBOutlet weak var accountNumberTextField : UITextField!
    @IBOutlet weak var branchCodeTextField    : UITextField!
    @IBOutlet weak var branchNameTextField    : UITextField!
    
    @IBOutlet weak var updateButtonView : UIView!
    @IBOutlet weak var nextButtton      : UIButton!
    
    //MARK:- Variables
    var isForUpdate = false
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.updateButtonView.isHidden = !self.isForUpdate
        self.nextButtton.isHidden      = self.isForUpdate
        
        if self.isForUpdate {
            if let bank   = BankDetail.shared {
                self.dataSetup(bank)
            }else {
               self.requestToGetDetails()
            }
        }
    }
        
    func dataSetup(_ bank: BankDetail) {
        
        self.bankHolderNameTextField.text   = bank.accountHolderName
        self.bankNameTextField.text         = bank.bankName
        self.accountNumberTextField.text    = bank.accountNumber
        self.branchCodeTextField.text       = bank.branchCode
        self.branchNameTextField.text       = bank.branchName
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        if self.isValidEntries() {
            self.requestToSubmitDetails()
        }
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        if self.isValidEntries() {
            self.requestToSubmitDetails()
        }
    }
}

//MARK:- APIs
extension BankingDetailsViewController {
    
    //TODO:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.bankHolderNameTextField.text!.isEmpty {
            errorMessage = "Please enter account holder name."
        }else  if self.bankNameTextField.text!.isEmpty {
            errorMessage = "Please enter bank name."
        }else  if self.accountNumberTextField.text!.isEmpty {
            errorMessage = "Please enter account number."
        }else  if self.branchCodeTextField.text!.isEmpty {
            errorMessage = "Please enter branch code."
        }else  if self.branchNameTextField.text!.isEmpty {
            errorMessage = "Please enter branch name."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
    
    //TODO:- Request
    func requestToSubmitDetails() {
        let param = [
                        "user_id"              : AppUser.shared.id!,
                        "account_holder_name"  : self.bankHolderNameTextField.text!,
                        "bank_name"            : self.bankNameTextField.text!,
                        "account_number"       : self.accountNumberTextField.text!,
                        "branch_code"          : self.branchCodeTextField.text!,
                        "branch_name"          : self.branchNameTextField.text!
                    ]
        
        print(param)
        
        let url = self.isForUpdate ? URLConstant.updateBankdetails : URLConstant.usersBankdetails
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(url, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        
                        let message = (response as! [String:Any])["msg"] as? String ?? ""
                        AlertView.show(self, image: #imageLiteral(resourceName: "Account verification"), message: message)
                        
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                            if self.isForUpdate {
                                _ = BankDetail(data)
                                self.navigationController?.popViewController(animated: true)
                            }else {
                                let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier:  "CreditRequestViewController") as! CreditRequestViewController
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
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
    
    func requestToGetDetails() {
        let param = [
                        "user_id":AppUser.shared.id!
                    ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.getBankDetails, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                                                
                        let bank = BankDetail(data)
                        self.dataSetup(bank)
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
}
