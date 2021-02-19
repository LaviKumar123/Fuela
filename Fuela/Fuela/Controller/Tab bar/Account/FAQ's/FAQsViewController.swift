//
//  FAQsViewController.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class FAQsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var faqTableView: UITableView!
    
    //MARK:- Variables
    var faqList = [FAQ]()
    var selectedIndex = -1

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.requestToGetFAQs()
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

//func setContent() {
//    if let descriptionHTML = self.contentData["Description"] as? String {
//        Indicator.shared.startAnimating(APP_DELEGATE.navigationController.view)
//
//        let content = "<html><body><p><font size=30>" + descriptionHTML + "</font></p></body></html>"
//
//        self.webView.loadHTMLString(content, baseURL: nil)
//    }
//}

//if let descriptionHTML = self.ucCategory[section]["Description"] as? String {
//                headerCell.descriptionLabel.setHTMLFromString(htmlText: descriptionHTML)
////                headerCell.helpTitleLabel.text   = "Here are just a few of the injuries we can help alleviate:"
//                headerCell.descriptionLabel.sizeToFit()
//
//                let height = (self.services.count == 0) ? headerCell.descriptionLabel.frame.height + 65 : headerCell.descriptionLabel.frame.height + 30
//                headerCell.descriptionSuperViewHeight.constant = height
//                headerCell.descriptionSuperView.isHidden = false
//            }

//MARK:- Table View Delegate And Data Source
extension FAQsViewController : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.faqList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQsTableViewCell", for: indexPath) as! FAQsTableViewCell
        
        cell.titleLabel.text = self.faqList[indexPath.row].heading
        
        if (self.selectedIndex == indexPath.row), let descriptionHTML = self.faqList[indexPath.row].message {
            cell.descriptionLabel.setHTMLFromString(htmlText: descriptionHTML)
        }else {
            cell.descriptionLabel.text = ""
        }
        
        cell.upDownIcon.image = (self.selectedIndex == indexPath.row) ? #imageLiteral(resourceName: "up-arrow") : #imageLiteral(resourceName: "down-arrow")
        
        cell.completion = { value in
            self.selectedIndex = (self.selectedIndex == indexPath.row) ? -1 : indexPath.row
            tableView.reloadData()
        }
        
        return cell
    }
}


extension FAQsViewController {
    func requestToGetFAQs() {
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToGetType(URLConstant.faq) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let dataArr = (response as! [String:Any])["data"] as? [[String:Any]] {
                                                
                        self.faqList = dataArr.map({FAQ($0)})
                        self.faqTableView.reloadData()
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
 
