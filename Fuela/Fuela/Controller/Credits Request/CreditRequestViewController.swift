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
    @IBOutlet weak var correncyButton: UIButton!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var amountTextField: UITextField!
    
    //MARK:- Varialble
    var isTermsAccept = false

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.requestToGetCorrency { (currency) in
            self.correncyButton.setTitle(currency, for: .normal)
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
        
       
    }
    
    @IBAction func registerNowButtonTapped(_ sender: UIButton) {
        if self.isValidEntries() {
            self.requestToRegisterNow()
        }
    }
}

//MARK:- APIs
extension CreditRequestViewController {
    
    //TODO:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.amountTextField.text!.isEmpty {
            errorMessage = "Please enter credit amount."
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
        let param = [
            "user_id" : AppUser.shared.id!,
            "value"   : self.amountTextField.text!
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
