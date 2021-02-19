//
//  WalletViewController.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var availableAmountLabel: UILabel!
    @IBOutlet weak var transactionTableView : UITableView!

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func requestButtonTapped(_ sender: UIButton) {
        let vc = HOME_STORYBOARD.instantiateViewController(identifier: "CreditRequestDetailsViewController") as! CreditRequestDetailsViewController
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

//MARK:- Table View Delegate And Data Source
extension WalletViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionTableViewCell", for: indexPath) as! RecentTransactionTableViewCell
        return cell
    }
}
