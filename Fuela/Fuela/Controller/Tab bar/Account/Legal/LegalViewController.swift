//
//  LegalViewController.swift
//  Fuela
//
//  Created by lavi on 10/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import WebKit

class LegalViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var webView: WKWebView!

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.requestToGetTermsAndCondition()
    }
    
    func setContent(_ legal: FAQ) {
        if let descriptionHTML = legal.message {
//            Indicator.shared.startAnimating(APP_DELEGATE.navigationController.view)
    
            let content = "<html><body><p><font size=50>" + descriptionHTML + "</font></p></body></html>"
            self.webView.scrollView.showsHorizontalScrollIndicator = false
            self.webView.scrollView.showsVerticalScrollIndicator = false
            self.webView.loadHTMLString(content, baseURL: nil)
        }
    }
    

    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }

}

extension LegalViewController {
    func requestToGetTermsAndCondition() {
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToGetType(URLConstant.legal) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        let legal = FAQ(data)
                        self.setContent(legal)
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
 
