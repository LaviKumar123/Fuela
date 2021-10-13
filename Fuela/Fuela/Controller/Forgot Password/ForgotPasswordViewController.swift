//
//  ForgotPasswordViewController.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var emailTextField: UITextField!

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func recoverButtonTapped(_ sender: UIButton) {
        if self.isValidEntries() {
            self.requestToForgot()
        }
    }
    
}

//MARK:- APIs
extension ForgotPasswordViewController {
    
    //MARK:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.emailTextField.text!.isEmpty {
            errorMessage = "Please enter your email."
//        }else if !Validation.isValidEmail(self.emailTextField.text!){
//            errorMessage = "Please enter valid email."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
    
    func requestToForgot() {
        let param = [
            "email":self.emailTextField.text!
        ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.forgotPassword, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                        let message = (response as! [String:Any])["msg"] as? String ?? ""
                        SendForgotEmailView.show(self, title: "Forgot Password", message: message)
                }else {
                    let message = (response as! [String:Any])["msg"] as? String ?? ""
                    AlertView.show(self, image:  #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image:  #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
}
