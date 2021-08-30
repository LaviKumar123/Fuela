//
//  HomeViewController.swift
//  Fuela
//
//  Created by lavi on 07/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import WebKit

class HomeViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var userImageView  : UIImageView!
    @IBOutlet weak var userNameLabel  : UILabel!
    @IBOutlet weak var userEmailLabel : UILabel!
    @IBOutlet weak var idNumberLabel  : UILabel!
    @IBOutlet weak var amountLabel    : UILabel!
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestToAuthenticatPaycentral()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dataSetup()
    }
    
    func dataSetup() {
        
        guard let appUser = AppUser.shared else { return }
        
        self.userNameLabel.text  = appUser.fullName!
        self.userEmailLabel.text = appUser.email!
        self.idNumberLabel.text  = appUser.idNumber!
        //        self.amountLabel.text    = appUser.amount
        
        if let url = URL(string: appUser.profileURL) {
            self.userImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder"), options: .continueInBackground, completed: nil)
        }
    }
    
    //MARK:- Button Action
    @IBAction func walletButtonTapped(_ sender: UIButton) {
        
        if AppUser.shared.isCardAdded {
            let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier: "CardDetailsViewController") as! CardDetailsViewController
            vc.completion = { (isAdded) in
                let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
                self.navigationController?.pushViewController(vc, animated: false)
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func findStationButtonTapped(_ sender: UIButton) {
        let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier:  "StationViewController") as! StationViewController
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func rewardsButtonTapped(_ sender: UIButton) {
        let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier: "RewardsViewController") as! RewardsViewController
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

extension HomeViewController {
    func requestToAuthenticatPaycentral() {
        
        let param = [
            "email" : "mandisi@phambiliscs.com",
            "password" : "HmZQyhfhQc"
        ] as [String: AnyObject]
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestWithoutBaseURL(URLConstant.payCentralBaseURL + URLConstant.authenticate, method: .post, header: [:], params: param) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if let token = (response as! [String:Any])["token"] as? String{
                    UserDefaults.standard.setValue(token, forKey: "Paycentral Auth Token")
                    if AppUser.shared.isCardAdded {
                        self.getCardBalance(AppUser.shared.cardNumber, token: token)
                    }else {
                        self.amountLabel.text = "00"
                    }
                }else if let errorMessage = (response as! [String:Any])["message"] as? String{
                    AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
    
    func getCardBalance(_ cardId: String, token: String) {
        
        Indicator.shared.startAnimating(self.view)
       
        let header = ["Authorization": "Bearer \(token)"]
        
        let url = URLConstant.payCentralBaseURL + URLConstant.cardBalance + "?cardIdentifier=\(cardId)"
        
        WebAPI.requestWithoutBaseURL(url, method: .get, header: header, params: [:]) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if let status = (response as! [String:Any])["status"] as? String{
                    if (status == "success"),
                       let balance = (response as! [String:Any])["Balance"] as? Int{
                        self.amountLabel.text = "R \(balance)"
                    }else if let errorMessage = (response as! [String:Any])["message"] as? String{
                        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
                    }
                }else if let errorMessage = (response as! [String:Any])["message"] as? String{
                    AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
}
