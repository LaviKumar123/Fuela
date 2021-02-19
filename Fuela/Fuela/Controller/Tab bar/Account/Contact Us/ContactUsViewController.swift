//
//  ContactUsViewController.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contactTableView: UITableView!
    
    //MARK:- Variables
    var titleArr = ["+27 7676567656", "fuela@support.com"]
    var icons:[UIImage] = [#imageLiteral(resourceName: "call contact us"),#imageLiteral(resourceName: "email contact us")]

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.requestToGetContactDetails()
    }
    
    func dataSetup(_ data: [String:Any]) {
        self.descriptionLabel.text = data["description"] as? String ?? ""
        let phone                  = data["contact_number"] as? String ?? ""
        let email                  = data["contact_email"] as? String ?? ""
        self.titleArr              = [phone, email]
        self.contactTableView.reloadData()
    }

    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Table View Delegate And Data Source
extension ContactUsViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsTableViewCell", for: indexPath) as! ContactUsTableViewCell
        cell.titleLabel.text = self.titleArr[indexPath.row]
        cell.iconView.image = self.icons[indexPath.row]
        return cell
    }
}


extension ContactUsViewController {
    
    func requestToGetContactDetails() {
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToGetType(URLConstant.getConatctDetail) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        self.dataSetup(data)
                    }
                }else {
                    let message = (response as! [String:Any])["Error"] as? String ?? ""
                    AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
}
