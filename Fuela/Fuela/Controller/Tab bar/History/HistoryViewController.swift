//
//  HistoryViewController.swift
//  Fuela
//
//  Created by lavi on 07/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet var headerButton: [UIButton]!
    @IBOutlet weak var indicatorView: UIView!

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.registerCells()
    }
    
    func registerCells() {
        self.transactionTableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
    }
    
    //MARK:- Button Action
    @IBAction func headerButtonTapped(_ sender: UIButton) {
//        for i in 0...1 {
//            if (self.headerButton[i] == sender) && sender.tag == i {
//                self.headerButton[i].setTitleColor(UIColor.black, for: .normal)
//            }else {
//                self.headerButton[i].setTitleColor(UIColor.gray, for: .normal)
//            }
//        }
        
        self.indicatorView.frame.origin.x = sender.frame.origin.x
        
        self.transactionTableView.reloadData()
    }
}


//MARK:- Table View Delegate And Data Source
extension HistoryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        
        cell.statusLabel.isHidden = (self.indicatorView.frame.origin.x == self.headerButton[1].frame.origin.x)
        cell.amountLabel.textColor = (self.indicatorView.frame.origin.x == self.headerButton[1].frame.origin.x) ? UIColor.gray : UIColor.systemGreen
        
        return cell
    }
}
