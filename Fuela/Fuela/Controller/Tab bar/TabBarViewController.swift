//
//  TabBarViewController.swift
//  GameChallenger
//
//  Created by lavi on 01/04/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import HTMLReader

class TabBarViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var titleLabel: [UILabel]!
    @IBOutlet weak var addNewButton: UIButton!
    
    //MARK:- Variables
    var homeViewController         : HomeViewController!
    var notificationViewController : NotificationViewController!
    var historyViewController      : HistoryViewController!
    var accountViewController      : AccountViewController!
    
    var viewControllers : [UIViewController]!
    var selectedIndex   : Int = 0
    
    var selectedIcons   : [UIImage] = [#imageLiteral(resourceName: "home red"),#imageLiteral(resourceName: "Notification Red"),#imageLiteral(resourceName: "History Red"),#imageLiteral(resourceName: "Account red")]
    var unselectedIcons : [UIImage] = [#imageLiteral(resourceName: "home grey"),#imageLiteral(resourceName: "Notification Grey"),#imageLiteral(resourceName: "History Grey"),#imageLiteral(resourceName: "Account Grey")]
    
    var isFromTabBar = false
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        if (AppUser.shared.isUserAccepted.uppercased() == "accepted".uppercased()) {
            self.selectedIndex = 0 //Home Section Selected
            self.getPersonalDetails()
        }else {
            self.selectedIndex = 3 //Account Section Selected
            self.getPersonalDetails()
        }
        
        
        if let fcmToken = UserDefaults.standard.value(forKey: "FCMToken") as? String{
            self.saveFCMToken(fcmToken)
        }
        
        self.configureViewControllers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func configureViewControllers() {
        
        self.homeViewController         = HOME_STORYBOARD.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.notificationViewController  = HOME_STORYBOARD.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController
        self.historyViewController       = HOME_STORYBOARD.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController
        self.accountViewController       = HOME_STORYBOARD.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController
        
        self.viewControllers             = [
                                                self.homeViewController,
                                                self.notificationViewController,
                                                self.historyViewController,
                                                self.accountViewController
                                            ]
        self.buttons[self.selectedIndex].isSelected   = true
        
//        self.barButtonTapped(self.buttons[self.selectedIndex])
        
        self.configureSelectedViewController(self.buttons[self.selectedIndex])
        self.manageSelectedButton(self.buttons[self.selectedIndex])
    }
    
    //MARK:- Button Action
    @IBAction func barButtonTapped(_ sender: UIButton) {
        if (AppUser.shared.isUserAccepted.uppercased() == "accepted".uppercased()) {
            self.configureSelectedViewController(sender)
            self.manageSelectedButton(sender)
        }else {
            if (sender.tag == 0) {
                let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "AccountVerificationViewController") as! AccountVerificationViewController
                vc.isFromHome = true
                self.navigationController!.pushViewController(vc, animated: true)
            }else if (sender.tag == 1) || (sender.tag == 3){
                self.configureSelectedViewController(sender)
                self.manageSelectedButton(sender)
            }
        }
    }
    
    @IBAction func addNewButtonTapped(_ sender: UIButton) {
        if (AppUser.shared.isUserAccepted.uppercased() == "accepted".uppercased()) {
            BottomPopupView.show(self)
        }
    }
    
    func manageSelectedButton(_ sender: UIButton) {
        for i in 0...3 {
            if self.buttons[i] == sender || sender.tag == i {
                self.buttons[i].setImage(self.selectedIcons[sender.tag], for: .normal)
                self.titleLabel[i].textColor = UIColor(red: 197/255, green: 0, blue: 0, alpha: 1.0)
            }else {
                self.buttons[i].setImage(self.unselectedIcons[i], for: .normal)
                self.titleLabel[i].textColor = UIColor.darkGray
            }
        }
    }
    
    func configureSelectedViewController(_ sender: UIButton) {
        
        let previousIndex = self.selectedIndex
        self.selectedIndex = sender.tag
        buttons[previousIndex].isSelected = false
        let previousVC = self.viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = viewControllers[self.selectedIndex]
        
        self.addChild(vc)
        vc.view.frame = contentView.bounds
        self.contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        self.tabBarView.superview?.bringSubviewToFront(self.tabBarView)
        self.addNewButton.superview?.bringSubviewToFront(self.addNewButton)
    }
}

extension TabBarViewController {
    func getPersonalDetails() {
        let param = [
            "user_id"   : "\(AppUser.shared.id!)"
        ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostWithDataWithoutHeader(URLConstant.getPersonalDetails, params: param, fileData: nil, fileKey: "", fileName: "") { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        
                        let appUser = AppUser(data)
                        
                        let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
                        UserDefaults.standard.set(archiveData, forKey: "Loggin User")
                        
                        if (appUser.isUserAccepted != "accepted") && (self.selectedIndex == 3) && !self.isFromTabBar{
                            let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier:  "TabBarViewController") as! TabBarViewController
                            vc.isFromTabBar = true
                            self.navigationController?.setViewControllers([vc], animated: false)
                        }else if (appUser.isUserAccepted == "accepted") {
                            self.homeViewController.dataSetup()
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
    
    func saveFCMToken(_ fcmToken: String) {
        let param = [
            "user_id": AppUser.shared.id!,
            "firebase_token" : fcmToken,
            "device_type" : "ios"
        ]
        
        print(param)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.setFCMToken, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            print(response)
            
            if isSuccess {
                if (response as! [String:Any])["result"] as! Int == 1{
                    
                }else {
                    
                }
            }else {
                
            }
        }
    }
}
