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
    @IBOutlet weak var rewardAmountLabel: UILabel!
    @IBOutlet weak var rewardTableView: UITableView!
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.headerViewSetup()
    }
    
    func headerViewSetup() {
        let nibViews = Bundle.main.loadNibNamed("RewardHeaderView", owner: self, options: nil)
        let stretchyHeaderView = nibViews!.first as! RewardHeaderView
        self.rewardTableView.addSubview(stretchyHeaderView)
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func addToWalletButtonTapped(_ sender: UIButton) {
        
    }
}

//MARK:- Table View Dlegate And Data Source
extension RewardsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardsTableViewCell", for: indexPath) as! RewardsTableViewCell
        return cell
    }
}
