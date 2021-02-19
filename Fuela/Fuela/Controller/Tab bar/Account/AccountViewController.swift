//
//  AccountViewController.swift
//  Fuela
//
//  Created by lavi on 07/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var menuTableView: UITableView!
    
    //MARK:- Variables
    var titles = ["Quotation Status", "Terms & Conditions", "Legal", "Help", "FAQ's", "Contact Us", "Change Password", "Logout"]
    var icons: [UIImage] = [#imageLiteral(resourceName: "Quotation Status"),#imageLiteral(resourceName: "Terms & Conditions"),#imageLiteral(resourceName: "Legal"),#imageLiteral(resourceName: "Help"),#imageLiteral(resourceName: "FAQ’s"),#imageLiteral(resourceName: "Contact Us"),#imageLiteral(resourceName: "Change Password"),#imageLiteral(resourceName: "Logout")]
    
    //MARK:- Variable
    var stretchyHeaderView : AccountHeaderView!
    
    
    //MARK:- Controlle Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.registerCells()
        self.headerViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.stretchyHeaderView != nil {
            self.stretchyHeaderView.layoutSubviews()
        }
    }
    
    func headerViewSetup() {
        let nibViews = Bundle.main.loadNibNamed("AccountHeaderView", owner: self, options: nil)
        self.stretchyHeaderView = nibViews!.first as? AccountHeaderView
        self.menuTableView.addSubview(self.stretchyHeaderView)
    }
    func registerCells() {
        self.menuTableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountTableViewCell")
    }
    
    //MARK:- Button Action
    @IBAction func deleteAccountButtonTapped(_ sender: UIButton) {
        OptionAlertView.show(self, title: "Delete Account", message: "Are you sure you want ot delete account?") { (action) in
            if action == "Yes" {
                self.requestToDeleteAccount()
            }
        }
    }
}


//MARK:- Table View Delegate And Data Source
extension AccountViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell", for: indexPath) as! AccountTableViewCell
        cell.titleLabel.text = self.titles[indexPath.row]
        cell.iconView.image = self.icons[indexPath.row]
        
        cell.titleLabel.textColor = (self.titles[indexPath.row] == "Logout") ? UIColor(red: 216/255, green: 59/255, blue: 23/255, alpha: 1.0) : UIColor.black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = self.titles[indexPath.row]
       
        
        switch title {
        case "Quotation Status":
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(identifier: "QuotationViewController") as! QuotationViewController
            vc.fromMenu = true
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case "Terms & Conditions":
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(identifier: "Terms_ConditionsViewController") as! Terms_ConditionsViewController
            self.navigationController?.pushViewController(vc, animated: false)
            break;
        case "Legal":
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(identifier: "LegalViewController") as! LegalViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case "Help":
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(identifier: "HelpViewController") as! HelpViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case "FAQ's":
            let vc = ACCOUNT_STORYBOARD.instantiateViewController(identifier: "FAQsViewController") as! FAQsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            break;
        case "Contact Us":
                let vc = ACCOUNT_STORYBOARD.instantiateViewController(identifier: "ContactUsViewController") as! ContactUsViewController
                self.navigationController?.pushViewController(vc, animated: true)
                break;
        case "Change Password":
                let vc = ACCOUNT_STORYBOARD.instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
                self.navigationController?.pushViewController(vc, animated: true)
                break;
        case "Logout":
            
            OptionAlertView.show(self, title: "Logout", message: "Are you sure you want to logout?") { (action) in
                if action == "Yes" {
                    self.goToLogin()
                }
            }
                
                break;
        default:
            print("Default")
        }
    }
    
    func goToLogin() {
        
        UserDefaults.standard.removeObject(forKey: "Loggin User")
        
        let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        self.navigationController?.setViewControllers([vc], animated: true)
    }
}


//MARK:- APIs
extension AccountViewController {
    func requestToDeleteAccount() {
        let param = [
                        "user_id": AppUser.shared.id!
                    ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.deleteUserAccount, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    self.goToLogin()
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
            
            let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
            UserDefaults.standard.set(archiveData, forKey: "Loggin User")
            
            let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier:  "TabBarViewController") as! TabBarViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
