//
//  CreditRequestViewController.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class CreditRequestViewController: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var amountTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var repaymentTextField: UITextField!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var otherReasonTextField: UITextField!
    @IBOutlet weak var otherReasonHeight: NSLayoutConstraint!
    
    //MARK:- Varialble
    var isTermsAccept = false
    var isFromRegistration = false

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestToGetCorrency { (currency) in
            self.amountTextField.title = "Credit Amount(\(currency))"
            self.amountTextField.selectedTitle = "Credit Amount(\(currency))"
        }
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBoxButtonTapped(_ sender: UIButton) {
        if self.checkboxButton.currentImage == #imageLiteral(resourceName: "checkbox") {
            self.isTermsAccept = false
            self.checkboxButton.setImage(#imageLiteral(resourceName: "square"), for: .normal)
        }else {
            self.isTermsAccept = true
            self.checkboxButton.setImage(#imageLiteral(resourceName: "checkbox"), for: .normal)
        }
    }
    
    @IBAction func termsInfoButtonTapped(_ sender: UIButton) {
        let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier: "Terms_ConditionsViewController") as! Terms_ConditionsViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func creditAmountButtonTapped(_ sender: UIButton) {
        let amountArr = ["1000","2500","3000","5000"]
        self.selectOption(self.amountTextField, title: "Credit Amount", options: amountArr)
    }
    
    @IBAction func repaymentButtonTapped(_ sender: UIButton) {
        let repaymentOptions = ["3 Months", "6 Months", "12 Months Revolving"]
        self.selectOption(self.repaymentTextField, title: "Repayment Period", options: repaymentOptions)
    }
    
    @IBAction func reasonButtonTapped(_ sender: UIButton) {
       let reasons = ["Work Travel", "Leisure Travel", "Emergency", "Budget Constraints", "Starting New Work", "Other"]
        self.selectOption(self.reasonTextField, title: "Credit Request Reason", options: reasons)
    }
    
    @IBAction func registerNowButtonTapped(_ sender: UIButton) {
        if self.isValidEntries() {
            self.requestToRegisterNow()
        }
    }
    
    
    //TODO:- State Picker
    func selectOption(_ sender: UITextField, title: String, options: [String]) {
        
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : title,
            titleFont           : UIFont.boldSystemFont(ofSize: 16),
            titleTextColor      : .white,
            titleBackground     : sender.backgroundColor,
            searchBarFont       : UIFont.systemFont(ofSize: 16),
            searchBarPlaceholder: title,
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : UIFont.systemFont(ofSize: 16),
            doneButtonTitle     : "Done",
            doneButtonColor     : sender.backgroundColor,
            doneButtonFont      : UIFont.boldSystemFont(ofSize: 16),
            checkMarkPosition   : .Right,
//            itemCheckedImage    : UIImage(named:"Graphics - Navbar & Toolbar Icons - White - Info"),
//            itemUncheckedImage  : UIImage(named:"Ellipse 29"),
            itemColor           : .black,
            itemFont            : UIFont.systemFont(ofSize: 20)
        )
        
        let picker = YBTextPicker.init(with: options , appearance: redAppearance,
                                       onCompletion: { (selectedIndexes, selectedValues) in
                                        if let selectedValue = selectedValues.first{
                                            
                                            sender.text = selectedValue
                                            sender.resignFirstResponder()
                                            
                                            if (sender == self.reasonTextField) {
                                                if (selectedValue == "Other") {
                                                    self.otherReasonHeight.constant = 45
                                                    self.otherReasonTextField.isHidden = false
                                                } else {
                                                    self.otherReasonTextField.text = ""
                                                    self.otherReasonHeight.constant = 0
                                                    self.otherReasonTextField.isHidden = true
                                                }
                                            }
                                        }else{
                                        }
                                       },
                                       onCancel: {
                                        print("Cancelled")
                                       }
        )
        
        picker.leftPadding = 20
        picker.rightPadding = 20
        picker.height = 350
        picker.preSelectedValues = [sender.text!]
        picker.setupLayout()
        picker.show(withAnimation: .FromBottom)
    }
    
}

//MARK:- APIs
extension CreditRequestViewController {
    
    //TODO:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.amountTextField.text!.isEmpty {
            errorMessage = "Please select credit amount."
        }else if self.repaymentTextField.text!.isEmpty {
            errorMessage = "Please select repayment period."
        }else if self.reasonTextField.text!.isEmpty {
            errorMessage = "Please select one of the reason."
        }else if (self.reasonTextField.text! == "Other") &&
                    (self.otherReasonTextField.text!.isEmpty){
            errorMessage = "Please enter your reason."
        }else if !self.isTermsAccept {
            errorMessage = "Please accept Terms and Conditions."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
    
    //TODO:- Request
    func requestToRegisterNow() {
        
        let reason = (self.reasonTextField.text! == "Other") ? self.otherReasonTextField.text! : self.reasonTextField.text!
        
        let param = [
            "user_id" : AppUser.shared.id!,
            "value"   : self.amountTextField.text!,
            "repayment" : self.repaymentTextField.text!,
            "cneedreason" : reason,
        ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.usersCredit, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        
                        let message = (response as! [String:Any])["msg"] as? String ?? ""
                        customSuccessPopUp(textToDisplay: message)
                        
                        let appUser = AppUser(data)
                        
                        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "AccountVerificationViewController") as! AccountVerificationViewController
                        vc.isFromRegistration = self.isFromRegistration
                        self.navigationController!.pushViewController(vc, animated: true)
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
    
    func requestToGetCorrency(completion: @escaping((String)->Void)) {
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToGetType(URLConstant.getCurrencyDetail) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
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
}
