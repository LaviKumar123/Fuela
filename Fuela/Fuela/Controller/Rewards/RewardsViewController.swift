//
//  RewardsViewController.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class RewardsViewController: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var rewardTableView: UITableView!
    @IBOutlet weak var redeemButton: UIButton!
    @IBOutlet weak var redeemButtonView: UIView!
    
    var rewardList = [Reward]()
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.rewardTableView.isHidden = true
        self.getRewardBalance()
    }
    
    func headerViewSetup(_ reward: Reward?) {
        let nibViews = Bundle.main.loadNibNamed("RewardHeaderView", owner: self, options: nil)
        let stretchyHeaderView = nibViews!.first as! RewardHeaderView
        if reward != nil {
            stretchyHeaderView.reward = reward
        }
        self.rewardTableView.addSubview(stretchyHeaderView)
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func addToWalletButtonTapped(_ sender: UIButton) {
        if (sender.currentTitle == "REDEEM NOW") {
            self.requestForRedeem()
        }
    }
}

//MARK:- Table View Dlegate And Data Source
extension RewardsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rewardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardsTableViewCell", for: indexPath) as! RewardsTableViewCell
        cell.reward = self.rewardList[indexPath.row]
        return cell
    }
}

//MARK:-
extension RewardsViewController {
    func getRewardBalance() {
        let param = [
                        "user_id": AppUser.shared.id!
                    ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.rewardBalance, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1,
                   let data = (response as! [String:Any])["data"] as? [String:Any]{
                    
                    self.redeemButtonView.isHidden = false
                    
                    let reward = Reward(data)
                    
                    self.headerViewSetup(reward)
                    
                    if reward.button_status == true {
                        self.redeemButton.setTitle("REDEEM NOW", for: .normal)
                    }else {
                        self.redeemButton.setTitle("TO BE REDEEM", for: .normal)
                    }
                    
                    self.getRewardList("")
                }else {
                    self.headerViewSetup(nil)
                    self.rewardTableView.isHidden = false
                    let message = (response as! [String:Any])["msg"] as? String ?? ""
                    AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                }
            }else {
                self.headerViewSetup(nil)
                self.rewardTableView.isHidden = false
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
    
    func getRewardList(_ lastRewardId: String) {
        let param = [
                        "user_id": AppUser.shared.id!,
                        "last_reward_id": lastRewardId
                    ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.recentRewards, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            self.rewardTableView.isHidden = false
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1,
                   let dataArr = (response as! [String:Any])["data"] as? [[String:Any]] {
                    self.rewardList = dataArr.map({Reward($0)})
                    self.rewardTableView.reloadData()
                    
                    if (self.rewardList.count > 0) {
                        self.rewardTableView.tableFooterView = UIView()
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
    
    func requestForRedeem() {
        let param = [
                        "user_id": AppUser.shared.id!
                    ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.doRequestReedem, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1{
                    let message = (response as! [String:Any])["msg"] as? String ?? ""
                    AlertView.show(self, image: #imageLiteral(resourceName: "Account verification"), message: message)
                    self.redeemButton.setTitle("TO BE REDEEM", for: .normal)
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
