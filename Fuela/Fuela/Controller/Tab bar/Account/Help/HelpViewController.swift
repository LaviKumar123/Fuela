//
//  HelpViewController.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var queryTextView: UITextView!
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let appUser = AppUser.shared {
            self.nameTextField.text  = appUser.fullName! + " " + appUser.surname!
            self.emailTextField.text = appUser.email!
        }
    }
    
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if self.isValidEntries() {
            self.requestToSubmitQuery()
        }
    }
}

extension HelpViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter query here..." {
            textView.textColor = UIColor.black
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = UIColor.lightGray
            textView.text = "Enter query here..."
        }
    }
}

//MARK:- APIs
extension HelpViewController {
    
    //MARK:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.nameTextField.text!.isEmpty {
            errorMessage = "Please enter name."
        }else if self.emailTextField.text!.isEmpty {
            errorMessage = "Please enter your email."
//        }else if !Validation.isValidEmail(self.emailTextField.text!){
//            errorMessage = "Please enter valid email."
        }else if self.queryTextView.text!.isEmpty || (self.queryTextView.text! == "Enter query here...") {
            errorMessage = "Please enter query."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
    
    func requestToSubmitQuery() {
        
        let param = [
            "user_id":AppUser.shared.id!,
            "name":self.nameTextField.text!,
            "email":self.emailTextField.text!,
            "query":self.queryTextView.text!
        ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.helpQuery, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    let message = (response as! [String:Any])["msg"] as? String ?? ""
                    AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer) in
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
