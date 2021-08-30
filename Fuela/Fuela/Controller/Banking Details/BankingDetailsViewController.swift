//
//  BankingDetailsViewController.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class BankingDetailsViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var bankHolderNameTextField : UITextField!
    @IBOutlet weak var bankNameTextField       : UITextField!
    @IBOutlet weak var accountTypeTextField    : UITextField!
    @IBOutlet weak var accountNumberTextField  : UITextField!
    @IBOutlet weak var branchCodeTextField     : UITextField!
    @IBOutlet weak var branchNameTextField     : UITextField!
    
    @IBOutlet weak var updateButtonView : UIView!
    @IBOutlet weak var nextButtton      : UIButton!
    
    //MARK:- Variables
    var isFromRegistration = false
    var isForUpdate = false
    var accountTypes = ["No Known", "Current", "Saving", "Transmission", "Bond", "Credit Card", "Subscription Share"]
    var bankNames = ["Absa", "Capitec", "FNB","Standard Bank","African Bank","Sasfin","Investec","Discovery Bank"]
    var currentValue: String = ""
    var activeElement: String?
    var isGetJobStatus = false
    var isTransectionCompleted = false
    
    //MARK:- Controller Life Cycle 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.updateButtonView.isHidden = !self.isForUpdate
        self.nextButtton.isHidden      = self.isForUpdate
        
        if self.isForUpdate {
            if let bank   = BankDetail.shared {
                self.dataSetup(bank)
            }else {
               self.requestToGetDetails()
            }
        }
    }
        
    func dataSetup(_ bank: BankDetail) {
        self.bankHolderNameTextField.text   = bank.accountHolderName
        self.bankNameTextField.text         = bank.bankName
        self.accountTypeTextField.text      = bank.accountType
        self.accountNumberTextField.text    = bank.accountNumber
        self.branchCodeTextField.text       = bank.branchCode
        self.branchNameTextField.text       = bank.branchName
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if self.isValidEntries() {
            self.requestToSubmitDetails()
        }
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        if self.isValidEntries() {
            self.requestToSubmitDetails()
        }
    }
    
    @IBAction func bankNameButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.selectBankName(self.bankNameTextField, stringArr: self.bankNames, title: "Select Bank Name.")
    }
    
    @IBAction func accountTypeButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.selectAccountType(self.accountTypeTextField, stringArr: self.accountTypes, title: "Select Account Type.")
    }
    
    
    //TODO:- State Picker
    func selectBankName(_ sender: UITextField, stringArr: [String], title: String) {
        
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : title,
            titleFont           : UIFont.boldSystemFont(ofSize: 16),
            titleTextColor      : .white,
            titleBackground     : sender.backgroundColor,
            searchBarFont       : UIFont.systemFont(ofSize: 16),
            searchBarPlaceholder: title,
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : UIFont.systemFont(ofSize: 16),
            doneButtonTitle     : "Done",
            doneButtonColor     : sender.backgroundColor,
            doneButtonFont      : UIFont.boldSystemFont(ofSize: 16),
            checkMarkPosition   : .Right,
//            itemCheckedImage    : UIImage(named:"Graphics - Navbar & Toolbar Icons - White - Info"),
//            itemUncheckedImage  : UIImage(named:"Ellipse 29"),
            itemColor           : .black,
            itemFont            : UIFont.systemFont(ofSize: 20)
        )
        
        let picker = YBTextPicker.init(with: stringArr , appearance: redAppearance,
                                       onCompletion: { (selectedIndexes, selectedValues) in
                                        if let selectedValue = selectedValues.first{
                                            sender.text = selectedValue
                                        }else{
                                            
                                        }
                                        sender.resignFirstResponder()
                                       },
                                       onCancel: {
                                        print("Cancelled")
                                        sender.resignFirstResponder()
                                       }
        )
        
        picker.leftPadding = 50
        picker.rightPadding = 50
        picker.height = 400
        picker.preSelectedValues = [sender.text!]
        picker.setupLayout()
        picker.show(withAnimation: .FromBottom)
    }
    
    func selectAccountType(_ sender: UITextField, stringArr: [String], title: String) {
        
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : title,
            titleFont           : UIFont.boldSystemFont(ofSize: 16),
            titleTextColor      : .white,
            titleBackground     : sender.backgroundColor,
            searchBarFont       : UIFont.systemFont(ofSize: 16),
            searchBarPlaceholder: title,
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : UIFont.systemFont(ofSize: 16),
            doneButtonTitle     : "Done",
            doneButtonColor     : sender.backgroundColor,
            doneButtonFont      : UIFont.boldSystemFont(ofSize: 16),
            checkMarkPosition   : .Right,
//            itemCheckedImage    : UIImage(named:"Graphics - Navbar & Toolbar Icons - White - Info"),
//            itemUncheckedImage  : UIImage(named:"Ellipse 29"),
            itemColor           : .black,
            itemFont            : UIFont.systemFont(ofSize: 20)
        )
        
        let picker = YBTextPicker.init(with: stringArr , appearance: redAppearance,
                                       onCompletion: { (selectedIndexes, selectedValues) in
                                        if let selectedValue = selectedValues.first{
                                            sender.text = selectedValue
                                        }else{
                                            
                                        }
                                        sender.resignFirstResponder()
                                       },
                                       onCancel: {
                                        print("Cancelled")
                                        sender.resignFirstResponder()
                                       }
        )
        
        picker.leftPadding = 50
        picker.rightPadding = 50
        picker.height = 400
        picker.preSelectedValues = [sender.text!]
        picker.setupLayout()
        picker.show(withAnimation: .FromBottom)
    }
}

//MARK:- Text Field Delegate
//extension BankingDetailsViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == self.accountTypeTextField {
//            self.optionPicker(textField, stringArr: self.accountTypes, title: "Select Account Type.")
//        }
//    }
//}

//MARK:- APIs
extension BankingDetailsViewController {
    
    //TODO:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.bankHolderNameTextField.text!.isEmpty {
            errorMessage = "Please enter account holder name."
        }else  if self.bankNameTextField.text!.isEmpty {
            errorMessage = "Please enter bank name."
        }else  if self.accountTypeTextField.text!.isEmpty {
            errorMessage = "Please select account type."
        }else  if self.accountNumberTextField.text!.isEmpty {
            errorMessage = "Please enter account number."
        }else  if self.branchCodeTextField.text!.isEmpty {
            errorMessage = "Please enter branch code."
        }else  if self.branchNameTextField.text!.isEmpty {
            errorMessage = "Please enter branch name."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
    
    //TODO:- Request
    func requestToSubmitDetails() {
        let param = [
                        "user_id"              : AppUser.shared.id!,
                        "account_holder_name"  : self.bankHolderNameTextField.text!,
                        "bank_name"            : self.bankNameTextField.text!,
                        "account_type"         : self.accountTypeTextField.text!,
                        "account_number"       : self.accountNumberTextField.text!,
                        "branch_code"          : self.branchCodeTextField.text!,
                        "branch_name"          : self.branchNameTextField.text!
                    ]
        
        print(param)
        
        let url = self.isForUpdate ? URLConstant.updateBankdetails : URLConstant.usersBankdetails
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(url, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        
                        let message = (response as! [String:Any])["msg"] as? String ?? ""
                        AlertView.show(self, image: #imageLiteral(resourceName: "Account verification"), message: message)
                        
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                            if self.isForUpdate {
                                _ = BankDetail(data)
                                self.navigationController?.popViewController(animated: true)
                            }else {
//                                let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier:  "CreditRequestViewController") as! CreditRequestViewController
//                                self.navigationController?.pushViewController(vc, animated: true)
//                                let appUser = AppUser(data)
                                let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier:  "CreditRequestViewController") as! CreditRequestViewController
                                vc.isFromRegistration = self.isFromRegistration
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
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
    
    func requestToGetDetails() {
        let param = [
                        "user_id":AppUser.shared.id!
                    ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.getBankDetails, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                                                
                        let bank = BankDetail(data)
                        self.dataSetup(bank)
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
    
    func requestToCompuscanAvsService(_ idNumber: String, surname: String, bankAccount: String, bankAccountType: Int, branchCode: String) {
        let params = """
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:web="http://webServices/">

    <soapenv:Header />

    <soapenv:Body>

        <web:SubmitFile>

            <pUsername>95266-1</pUsername>

            <pPassword>devtest</pPassword>

            <pMyOrigin>CC-SOAPUI</pMyOrigin>

            <pVersion>1.0</pVersion>

            <pSubmissionType>RS</pSubmissionType>

            <pFileContent>

                <![CDATA[
                     <AVS_TRANSACTIONS>
                     <VERSION>1.0</VERSION>
                     <DATE_CREATED>20120530</DATE_CREATED>
                     <RECORDS>
                       <RECORD num='1'>
                       <BANK_BRANCH_CD>\(branchCode)</BANK_BRANCH_CD>
                       <BANK_ACC>\(bankAccount)</BANK_ACC>
                       <BANK_ACC_TYPE>\(bankAccountType)</BANK_ACC_TYPE>
                       <ID_NUMBER>\(idNumber)</ID_NUMBER>
                       <INITIALS>J</INITIALS>
                       <SURNAME>\(surname)</SURNAME>
                       </RECORD>
                     </RECORDS>
                     </AVS_TRANSACTIONS>]]>
            </pFileContent>

        </web:SubmitFile>

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
            
//            Indicator.shared.stopAnimating()
            
//            print(response)
            
            if isSuccess {
                
                if let xmlStr = response as? String {
                    
                    let xmlData = xmlStr.data(using: .utf8)
                    
                    let xmlParser = XMLParser(data: xmlData!)
                    
                    xmlParser.delegate = self
                    
                    xmlParser.parse()
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
}


extension BankingDetailsViewController: XMLParserDelegate {
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
            if self.isTransectionCompleted {
                if self.isGetJobStatus {
                    self.currentValue += string
                }else {
                    self.isGetJobStatus = true
                    print(string)
                    
                    UserDefaults.standard.setValue(string, forKey: "job_id")
                    
                  self.requestToSubmitDetails()
                }
            }else {
                self.showAlert(title: "Compuscan", message:  "Avs transaction failed!", completion: nil)
            }
            
        }else if self.activeElement == "transactionCompleted" {
            if string == "true" {
                self.isTransectionCompleted = true
                
            }else {
                self.isTransectionCompleted = false
                Indicator.shared.stopAnimating()
                self.showAlert(title: "Compuscan", message:  "Avs transaction failed!", completion: nil)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "retData" {
            if self.isGetJobStatus && self.currentValue != "" {
                print(self.currentValue)
                
                let components = self.currentValue.components(separatedBy: "\n")
                
                let responseData = self.getResponseData(components)
                
                print(responseData as NSDictionary)
            }
        }
    }
    
    // Just in case, if there's an error, report it. (We don't want to fly blind here.)
    
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
}

//extension String {
//
//    func slice(from: String, to: String) -> String? {
//
//        return (range(of: from)?.upperBound).flatMap { substringFrom in
//            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
//                String(self[substringFrom..<substringTo])
//            }
//        }
//    }
//}
