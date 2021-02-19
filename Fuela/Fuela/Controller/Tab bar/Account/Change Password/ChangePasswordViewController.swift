//
//  ChangePasswordViewController.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var conPasswordTextField: UITextField!

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func eyeButtonTapped(_ sender: UIButton) {
        self.oldPasswordTextField.isSecureTextEntry = !self.oldPasswordTextField.isSecureTextEntry
    }
    
    @IBAction func changeButtonTapped(_ sender: UIButton) {
        if self.isValidEntries() {
            self.requestToChangePassword()
        }
    }
}

//MARK:- APIs
extension ChangePasswordViewController {
    
    // Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.oldPasswordTextField.text!.isEmpty {
            errorMessage = "Please enter old password."
        }else if !Validation.isPwdLength(password: self.oldPasswordTextField.text!)  {
            errorMessage = "Old password length should be minimum 8 characters."
        }else if self.newPasswordTextField.text!.isEmpty {
            errorMessage = "Please enter new password."
        }else if !Validation.isPwdLength(password: self.newPasswordTextField.text!)  {
            errorMessage = "New password length should be minimum 8 characters."
        }else if self.conPasswordTextField.text!.isEmpty {
            errorMessage = "Please enter confirm password."
        }else if !Validation.isPwdLength(password: self.conPasswordTextField.text!)  {
            errorMessage = "Confirm Password length should be minimum 8 characters."
        }else if !Validation.isPasswordSame(password: self.newPasswordTextField.text!, confirmPassword: self.conPasswordTextField.text!){
            errorMessage = "Password doesn't match, please enter same password."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
    
    func requestToChangePassword() {
        let param = [
                        "user_id":AppUser.shared.id!,
                        "old_pass":self.oldPasswordTextField.text!,
                        "new_pass":self.newPasswordTextField.text!,
                        "confirm_pass":self.conPasswordTextField.text!
                    ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
       WebAPI.requestToPostBodyWithHeader(URLConstant.changePassword, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    
                    let message = (response as! [String:Any])["msg"] as? String ?? ""
                    AlertView.show(self, image: #imageLiteral(resourceName: "Account verification"), message: message)
                    
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }else {
                     let message = (response as! [String:Any])["msg"] as? String ?? ""
                    AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
}
