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
    private var activeElement: String?
    var isGetJobStatus = false

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
        if let jobID = UserDefaults.standard.value(forKey: "job_id") as? String {
            self.requestToCompuscanJobStatus(jobID)
        }
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


//MARK:- Compuscan API
extension WalletViewController {
    
    func requestToCompuscanJobStatus(_ jobId: String) {
        let params = """
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:web="http://webServices/">

<soapenv:Header />


<soapenv:Body>


    <web:CheckStatus>


        <pUsername>95266-1</pUsername>


        <pPassword>devtest</pPassword>


        <pMyOrigin>CC-SOAPUI</pMyOrigin>


        <pVersion>1.0</pVersion>


        <pJobId>\(jobId)</pJobId>

    </web:CheckStatus>

</soapenv:Body>

</soapenv:Envelope>
"""
        let apiURL = "https://webservices-uat.compuscan.co.za/AVSService?wsdl"
        
        let header = [
            "content-type" : "text/xml:  charset=utf-8",
            "cache-control" : "no-cache"
        ]
        
        print(params)
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostSOAPApiWithHeader(apiURL, params, header: header) { (response, isSuccess) in
            
            print(response)
            
            if isSuccess {
                
                if let xmlStr = response as? String {
                    
                    let xmlData = xmlStr.data(using: .utf8)
                    
                    let xmlParser = XMLParser(data: xmlData!)
                    
                    xmlParser.delegate = self
                    
                    xmlParser.parse()
                }
            }else {
                Indicator.shared.stopAnimating()
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
}

extension WalletViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.activeElement = elementName
        
        //        print(elementName)
        //        print(namespaceURI)
        //        print(qName)
        //        print(attributeDict)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.activeElement == "retData" {
            //            print(string)
            
            if self.isGetJobStatus {
                self.currentValue += string
            }else {
                self.isGetJobStatus = true
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "retData" {
            Indicator.shared.stopAnimating()
            if self.isGetJobStatus && self.currentValue != "" {
                print(self.currentValue)
                
                let components = self.currentValue.components(separatedBy: "\n")
                
                let responseData = self.getResponseData(components)
                
                print(responseData as NSDictionary)
                
                if self.isAccountFound(responseData) {
                    let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier: "CreditRequestDetailsViewController") as! CreditRequestDetailsViewController
                    self.navigationController!.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        self.currentValue = ""
    }
    
    func getResponseData(_ components: [String])-> [String:Any] {
        var responseData = [String:Any]()
        
        let serialQueue = DispatchQueue(label: "html:parsing")
        
        serialQueue.sync {
            for component in components {
                
                if let keyName = component.slice(from: "</", to: ">"),
                   let keyValue = component.slice(from: "<\(keyName)>", to: "</\(keyName)>"){
                    responseData[keyName] = keyValue
                }
            }
        }
        
        return responseData
    }
    
    func isAccountFound(_ responceData: [String:Any])-> Bool {
        let accountValidaton = [
            "Y" : "Account found",
            "N" : "Account not found",
            "U" : "Account unprocessed due to SLA exceeded",
            "F" : "Account validation failed"
        ]
        
        if let accountFoundStatus = responceData["ACC_FOUND"] as? String{
            if accountFoundStatus == "Y" {
                return true
            }else {
                let message = accountValidaton[accountFoundStatus] ?? "Some error occured"
                self.showAlert(title: "Error", message: message, completion: nil)
                return false
            }
        }else {
            return false
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
