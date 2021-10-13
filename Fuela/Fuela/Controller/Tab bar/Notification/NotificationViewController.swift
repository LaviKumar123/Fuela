//
//  NotificationViewController.swift
//  Fuela
//
//  Created by lavi on 07/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var notificationTableView: UITableView!
    
    var notifications = [NotificationInfo]()

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.registerCells()
        self.getNotification()
    }
    
    func registerCells() {
        self.notificationTableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
    }
}


//MARK:- Table View Delegate And Data Source
extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.notification = self.notifications[indexPath.row]
        return cell
    }
}

//MARK:- API
extension NotificationViewController {
    func getNotification() {
        let param = [
            "user_id": AppUser.shared.id!
        ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.getNotification, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                if (response as! [String:Any])["result"] as! Int == 1,
                   let dataArr = (response as! [String:Any])["data"] as? [[String:Any]] {
                    self.notifications = dataArr.map({NotificationInfo($0)})
                    self.notificationTableView.reloadData()
                    self.notificationTableView.tableFooterView = UIView()
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
