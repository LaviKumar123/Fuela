//
//  QuotationViewController.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class QuotationViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var creditAmountLabel  : UILabel!
    @IBOutlet weak var intrerestRateLabel : UILabel!
    @IBOutlet weak var returnAmountLabel  : UILabel!
    @IBOutlet weak var descriptionLabel   : UILabel!
    @IBOutlet weak var rejectButton       : UIButton!
    @IBOutlet weak var acceptButton       : UIButton!
    @IBOutlet weak var scrollView         : UIScrollView!
    
    //MARK:- Variable
    var fromMenu = false

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scrollView.isHidden = true
//        if let quotation = Quotation.shared {
//            self.dataSetup(quotation)
//        }else {
            self.requestToGetQuotationData()
//        }
    }
    
    func dataSetup(_ quotation: Quotation)-> String {
        
        if (quotation.adminStatus == "Pending") || (quotation.adminStatus == "") {
            return "Pending"
        }else if quotation.adminStatus == "Reject" {
            return "Admin Reject"
        }else if quotation.userResponse == "Accept" {
            self.rejectButton.isHidden = true
            self.acceptButton.isHidden = true
        }else if quotation.userResponse == "Reject" {
            return "Reject"
        }
        
        self.creditAmountLabel.text = "R \(quotation.adminValue!)"
        self.intrerestRateLabel.text = "\(quotation.interestRate!)%"
        self.returnAmountLabel.text = "R \(quotation.userDemand!)"
        self.descriptionLabel.text = "You Qualify for R \(quotation.adminValue!) and Your Requested Credit-R \(quotation.userDemand!) was Approved"
        
        self.scrollView.isHidden = false
        
        return ""
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func denyButtonTapped(_ sender: UIButton) {
        OptionAlertView.show(self, title: "Quotation", message: "Are you sure you want to reject quotation?") { (action) in
            if (action == "Yes") {
                self.requestToUpdateStatus("Reject")
            }
        }
    }
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        
        OptionAlertView.show(self, title: "Quotation", message: "Are you sure you want to accept quotation?") { (action) in
            if (action == "Yes") {
                self.requestToUpdateStatus("Accept")
            }
        }
    }
}

//MARK:- APIs
extension QuotationViewController {
    func requestToGetQuotationData() {
        let param = [
                        "user_id": AppUser.shared.id!
                    ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.quotation, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    self.manageResponse(response: response)
                }else {
//                    let message = (response as! [String:Any])["msg"] as? String ?? ""
//                    self.gotBack(message)
                    self.manageResponse(response: response)
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func manageResponse(response: AnyObject) {
        if let data = (response as! [String:Any])["data"] as? [String:Any] {
            let quotation = Quotation(data)
            let status = self.dataSetup(quotation)
            if (status == "Admin Reject") {
                let message = (response as! [String:Any])["msg"] as? String ?? ""
                OptionAlertView.show(self, title: "Quotation", message: message) { (action) in
                    if (action == "Yes") {
                        let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier: "CreditRequestDetailsViewController") as! CreditRequestDetailsViewController
                        vc.isFromMenu = true
                        self.navigationController!.pushViewController(vc, animated: true)
                    }else {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else if (status == "Reject") {
                let message = (response as! [String:Any])["msg"] as? String ?? ""
                self.gotBack(message)
            }else if (status == "Pending") {
                let message = (response as! [String:Any])["msg"] as? String ?? ""
                self.gotBack(message)
            }
        }
    }
    
    func requestToUpdateStatus(_ status: String) {
        let param = [
                        "user_id": AppUser.shared.id!,
                        "status":status
                    ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.quatationStatus, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    let message = (response as! [String:Any])["msg"] as? String ?? ""
                    AlertView.show(self, image: #imageLiteral(resourceName: "Account verification"), message: message)
                    if status == "Accept" {
                        self.rejectButton.isHidden = true
                        self.acceptButton.isHidden = true
                    }else {
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
    
    func gotBack(_ message: String) {
        AlertWithOkView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message, actionTitle: "GO TO HOME")
        AlertWithOkView.completion = { (action) in
            if self.fromMenu {
                self.navigationController?.popViewController(animated: true)
            }else {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: LoginViewController.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
    }
}
