//
//  ViewController.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import CoreTelephony

class LoginViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var countryCode = ""
    
    var currentValue          : String?
    private var activeElement : String?
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getRegionCode()
    }
    
    func getRegionCode(){
        let locale = Locale.current
        //        print(locale.regionCode)
    }
    
    //MARK:- Button Action
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        if self.isValidEntries() {
            self.requestToLogin()
        }
    }
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func forgotButtonTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier:  "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.emailTextField.text!.isEmpty {
            errorMessage = "Please enter your email."
//        }else if !Validation.isValidEmail(self.emailTextField.text!){
//            errorMessage = "Please enter valid email."
        }else if self.passwordTextField.text!.isEmpty {
            errorMessage = "Please enter password."
        }else if !Validation.isPwdLength(password: self.passwordTextField.text!)  {
            errorMessage = "Password length should be minimum 6 characters."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
}

//MARK:- APIs
extension LoginViewController {
    func requestToLogin() {
        let param = [
            "email"    : self.emailTextField.text!,
            "password" : self.passwordTextField.text!,
        ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostWithDataWithoutHeader(URLConstant.login, params: param, fileData: nil, fileKey: "", fileName: ""){ (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        
                        let message = (response as! [String:Any])["msg"] as? String ?? ""
                        customSuccessPopUp(textToDisplay: "Login Successful.")
                        
                        let appUser = AppUser(data)
                        self.redirectToStepPage(appUser.step, data: data)
                    }
                }else {
                    if let errors = (response as! [String:Any])["errors"] as? [String:Any] {
                        for (key,value) in errors {
                            AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: value as! String)
                            return
                        }
                    }else {
                        let message = (response as! [String:Any])["msg"] as? String ?? ""
                        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                    }
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
    
    func redirectToStepPage(_ step: Int, data : [String:Any]) {
        
        switch step {
        case 2:
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier:  "WorkDetailsViewController") as! WorkDetailsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 3:
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier:  "IncomeDetailsViewController") as! IncomeDetailsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 4:
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier:  "BankingDetailsViewController") as! BankingDetailsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case 5:
            let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier:  "CreditRequestViewController") as! CreditRequestViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        default:
            let appUser = AppUser(data)
            let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            UserDefaults.standard.set(archiveData, forKey: "Loggin User")
            
            if appUser.isUserAccepted == "accepted" {
                let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier:  "TabBarViewController") as! TabBarViewController
                self.navigationController?.setViewControllers([vc], animated: true)
            }else {
                let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "AccountVerificationViewController") as! AccountVerificationViewController
                self.navigationController!.pushViewController(vc, animated: true)
            }
        }
    }
}
