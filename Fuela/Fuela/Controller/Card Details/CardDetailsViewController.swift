//
//  CardDetailsViewController.swift
//  Fuela
//
//  Created by APPLE on 02/08/21.
//  Copyright © 2021 lavi. All rights reserved.
//

import UIKit

class CardDetailsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var cardNoTextField  : UITextField!
    @IBOutlet weak var updateButtonView : UIView!
    @IBOutlet weak var nextButtton      : UIButton!
    
    var completion: ((String)->Void)?
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.updateButtonView.isHidden = !AppUser.shared.isCardAdded
        self.nextButtton.isHidden      = AppUser.shared.isCardAdded
        
        if AppUser.shared.isCardAdded {
            self.getCardDetails()
        }
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if self.cardNoTextField.text!.isEmpty {
            AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: "Please enter card number")
        }else {
            self.requestToAddCard()
        }
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        if self.cardNoTextField.text!.isEmpty {
            AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: "Please enter card number")
        }else {
            self.requestToAddCard()
        }
    }
}

//MARK:- APIs
extension CardDetailsViewController {
    func requestToAddCard() {
        let param = [
            "user_id": AppUser.shared.id!,
            "card_no": self.cardNoTextField.text!,
        ] as [String:AnyObject]
        
        print(param)
        
        let url = (AppUser.shared.isCardAdded) ? URLConstant.updateCardNo : URLConstant.addCardNo
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(url, param as [String : AnyObject], header: [:]) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        
                        let message = (response as! [String:Any])["msg"] as? String ?? ""
                        AlertView.show(self, image: #imageLiteral(resourceName: "Account verification"), message: message)
                        
                        let appUser = AppUser(data)
                        
                        let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
                        UserDefaults.standard.set(archiveData, forKey: "Loggin User")
                        
                        self.navigationController?.popViewController(animated: false)
                        
                        if (self.completion != nil) {
                            self.completion!("Added")
                        }
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
    
    func getCardDetails() {
        let param = [
            "user_id": AppUser.shared.id!
        ] as [String:AnyObject]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.getCardDetails, param as [String : AnyObject], header: [:]) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any],
                       let card_number = data["card_number"] as? String{
                        self.cardNoTextField.text = card_number
                    }else {
                        let message = (response as! [String:Any])["msg"] as? String ?? ""
                        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
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
