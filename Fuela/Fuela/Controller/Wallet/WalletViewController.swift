//
//  WalletViewController.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import HTMLReader

class WalletViewController: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var availableAmountLabel: UILabel!
    @IBOutlet weak var transactionTableView : UITableView!
    
    var currentValue: String = ""
    var activeElement: String?
    var isGetJobStatus = false
    var payCentralAuthToken = ""
    
    var dataCount = -1
    var transactions = [Transaction]()

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view)
        
        if let authToken = UserDefaults.standard.value(forKey: "Paycentral Auth Token") as? String {
            self.payCentralAuthToken = authToken
            self.getCardBalance(AppUser.shared.cardNumber)
            self.getCardStatement(AppUser.shared.cardNumber)
        }
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func requestButtonTapped(_ sender: UIButton) {
        self.requestToGetQuotationData()
    }
}

//MARK:- Table View Delegate And Data Source
extension WalletViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionTableViewCell", for: indexPath) as! RecentTransactionTableViewCell
        cell.transaction = self.transactions[indexPath.row]
        return cell
    }
}

//MARK:- APIs
extension WalletViewController {
    
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
                    let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier: "CreditRequestDetailsViewController") as! CreditRequestDetailsViewController
                    self.navigationController!.pushViewController(vc, animated: true)
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
    
    func getCardBalance(_ cardId: String) {
        
        Indicator.shared.startAnimating(self.view)
       
        let header = ["Authorization": "Bearer \(self.payCentralAuthToken)"]
        
        let url = URLConstant.payCentralBaseURL + URLConstant.cardBalance + "?cardIdentifier=\(cardId)"
        
        WebAPI.requestWithoutBaseURL(url, method: .get, header: header, params: [:]) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if let status = (response as! [String:Any])["status"] as? String{
                    if (status == "success"),
                       let balance = (response as! [String:Any])["Balance"] as? Int{
                        self.availableAmountLabel.text = "R \(balance)"
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

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
