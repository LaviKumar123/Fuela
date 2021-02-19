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
        let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier: "WalletViewController") as! WalletViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
