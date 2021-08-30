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
    
    var payCentralAuthToken = ""
    var transactions = [Transaction]()

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.registerCells()
        
        if let authToken = UserDefaults.standard.value(forKey: "Paycentral Auth Token") as? String {
            self.payCentralAuthToken = authToken
            self.getCardStatement(AppUser.shared.cardNumber)
        }
    }
    
//    func registerCells() {
//        self.transactionTableView.register(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionTableViewCell")
//    }
    
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
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionTableViewCell", for: indexPath) as! RecentTransactionTableViewCell
        cell.transaction = self.transactions[indexPath.row]
        return cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
//
//        cell.statusLabel.isHidden = (self.indicatorView.frame.origin.x == self.headerButton[1].frame.origin.x)
//        cell.amountLabel.textColor = (self.indicatorView.frame.origin.x == self.headerButton[1].frame.origin.x) ? UIColor.gray : UIColor.systemGreen
//
//        return cell
    }
}

//MARK:- APIs
extension HistoryViewController {
    
    func getCardStatement(_ cardId: String) {
        
        let previousMonthDate = self.getPreviousMonthCurrentDate() ?? Date()
        
        let param = [
            "cardIdentifier" : cardId,
            "fromdate" : self.getConvetedDate("dd/MM/yyyy", date: previousMonthDate),
//            "profile_type": "2",
            "todate" : self.getConvetedDate("dd/MM/yyyy", date: Date())
        ] as [String: AnyObject]
        
        let header = ["Authorization": "Bearer \(self.payCentralAuthToken)"]
        
        Indicator.shared.startAnimating(self.view)
        
        let url = URLConstant.payCentralBaseURL + URLConstant.cardStatement
        
        WebAPI.requestWithoutBaseURL(url, method: .post, header: header, params: param) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                if let status = (response as! [String:Any])["status"] as? String{
                    if (status == "success"),
                       let transactions = (response as! [String:Any])["response"] as? [[String:Any]]{
                        self.transactions = transactions.map({Transaction($0)})
                        if (self.transactions.count > 0) {
                            self.transactionTableView.tableFooterView = UIView()
                        }
                        self.transactionTableView.reloadData()
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
    
    func getConvetedDate(_ inFormat: String, date: Date)-> String {
        let convertedDate = "\(date)".convertDateFormat(currentFormat: "yyyy-MM-dd HH:mm:ss Z", newFormat: "dd/MM/yyyy")
        return convertedDate
    }
    
    func getPreviousMonthCurrentDate()-> Date? {
        if let date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) {
            return date
        }else {
            return nil
        }
    }
}
