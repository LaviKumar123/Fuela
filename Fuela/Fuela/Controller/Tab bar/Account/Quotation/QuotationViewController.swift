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
    @IBOutlet weak var scrollView         : UIScrollView!
    
    //MARK:- Variable
    var fromMenu = false

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scrollView.isHidden = true
        if let quotation = Quotation.shared {
            self.dataSetup(quotation)
        }else {
            self.requestToGetQuotationData()
        }
    }
    
    func dataSetup(_ quotation: Quotation) {
        self.creditAmountLabel.text = "R \(quotation.adminValue!)"
        self.intrerestRateLabel.text = "\(quotation.interestRate!)%"
        self.returnAmountLabel.text = "R \(quotation.userDemand!)"
        self.scrollView.isHidden = false
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func downloadButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func denyButtonTapped(_ sender: UIButton) {
        self.requestToUpdateStatus("rejected")
    }
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        self.requestToUpdateStatus("accepted")
        
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
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        let quotation = Quotation(data)
                        self.dataSetup(quotation)
                    }
                }else {
                    let message = (response as! [String:Any])["msg"] as? String ?? ""
                    AlertWithOkView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
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
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    func requestToUpdateStatus(_ status: String) {
        let param = [
                        "user_id": AppUser.shared.id!,
                        "key":status
                    ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.quotation, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        
                        let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
                        UserDefaults.standard.set(archiveData, forKey: "Loggin User")
                        
                        _ = AppUser(data)
                        
                        let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier:  "TabBarViewController") as! TabBarViewController
                        self.navigationController?.pushViewController(vc, animated: true)
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
