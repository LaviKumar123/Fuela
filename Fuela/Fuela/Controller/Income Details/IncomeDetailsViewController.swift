//
//  IncomeDetailsViewController.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class IncomeDetailsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var sourceTextField           : UITextField!
    @IBOutlet weak var salaryDateTextField       : UITextField!
    @IBOutlet weak var additionalIncomeTextField : UITextField!
    @IBOutlet weak var totalIncomeTextField      : UITextField!
    @IBOutlet weak var totalExpTextField         : UITextField!
    @IBOutlet weak var netIncomeTextField        : UITextField!
    
    @IBOutlet weak var updateButtonView : UIView!
    @IBOutlet weak var nextButtton      : UIButton!
    @IBOutlet var currencyButton        : [UIButton]!
    
    //MARK:- Variables
    var isForUpdate = false
    var isFromRegistration = false
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateButtonView.isHidden = !self.isForUpdate
        self.nextButtton.isHidden      = self.isForUpdate
        
        self.requestToGetCorrency { (currency) in
            for button in self.currencyButton {
                button.setTitle(currency, for: .normal)
            }
        }
        
        if self.isForUpdate {
            if let income = IncomeDetail.shared {
                self.dataSetup(income)
            }else {
                self.requestToGetDetails()
            }
        }
        
//        let datePickerView:UIDatePicker = UIDatePicker()
//        datePickerView.minimumDate = Date()
//        datePickerView.datePickerMode = UIDatePicker.Mode.date
//        self.salaryDateTextField.inputView = datePickerView
//        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
           
    func dataSetup(_ income: IncomeDetail) {
        
        self.sourceTextField.text           = income.sourceIncome
        self.salaryDateTextField.text       = income.salaryDate
        self.additionalIncomeTextField.text = income.additionalIncome
        self.totalIncomeTextField.text      = income.totalIncome
        self.totalExpTextField.text         = income.totalExpenses
        self.netIncomeTextField.text        = income.netIncome
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
    
    @IBAction func sourceOfIncomeButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let incomeSourceArr = ["Salary", "Wages", "Interest Allowance", "Self Employment"]
        self.selectIncomeSource(self.sourceTextField, stringArr:incomeSourceArr, title: "Select Source Of Income")
    }
    
    @IBAction func salaryDateButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        let daysArr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
        self.selectDay(self.salaryDateTextField, stringArr:daysArr, title: "Select Salary Date")
    }
    
    //TODO:- Date Picker
//    @objc func datePickerValueChanged(sender:UIDatePicker) {
//
//        let dateFormatter = DateFormatter()
//
//        dateFormatter.dateStyle = DateFormatter.Style.medium
//
//        dateFormatter.timeStyle = DateFormatter.Style.none
//
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        self.salaryDateTextField.text = dateFormatter.string(from: sender.date)
//    }
    
    //TODO:- State Picker
    func selectIncomeSource(_ sender: UITextField, stringArr: [String], title: String) {

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
                                            sender.resignFirstResponder()
                                        }else{
                                        }
        },
                                       onCancel: {
                                        print("Cancelled")
        }
        )

        picker.leftPadding = 70
        picker.rightPadding = 70
        picker.height = 300
        picker.preSelectedValues = [sender.text!]
        picker.setupLayout()
        picker.show(withAnimation: .FromBottom)
    }
    
    func selectDay(_ sender: UITextField, stringArr: [String], title: String) {

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
                                            sender.resignFirstResponder()
                                        }else{
                                        }
        },
                                       onCancel: {
                                        print("Cancelled")
        }
        )

        picker.leftPadding = 100
        picker.rightPadding = 100
        picker.height = 450
        picker.preSelectedValues = [sender.text!]
        picker.setupLayout()
        picker.show(withAnimation: .FromBottom)
    }
}



//MARK:- APIs
extension IncomeDetailsViewController {
    
    //TODO:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.sourceTextField.text!.isEmpty {
            errorMessage = "Please enter source of income."
        }else  if self.salaryDateTextField.text!.isEmpty {
            errorMessage = "Please select salary date."
        }else  if self.netIncomeTextField.text!.isEmpty {
            errorMessage = "Please enter income."
        }else  if self.additionalIncomeTextField.text!.isEmpty {
            errorMessage = "Please enter additional income."
        }else  if self.totalIncomeTextField.text!.isEmpty {
            errorMessage = "Please enter total income."
        }else  if self.totalExpTextField.text!.isEmpty {
            errorMessage = "Please enter total expenses."
//        }else  if self.netIncomeTextField.text!.isEmpty {
//            errorMessage = "Please enter net income."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
    
    //TODO:- Request
    func requestToSubmitDetails() {
        let param = [
                        "user_id"           : AppUser.shared.id!,
                        "source_income"     : self.sourceTextField.text!,
                        "salary_date"       : self.salaryDateTextField.text!,
                        "additional_income" : self.additionalIncomeTextField.text!,
                        "total_income"      : self.totalIncomeTextField.text!,
                        "total_expenses"    : self.totalExpTextField.text!,
                        "net_income"        : self.netIncomeTextField.text!
                    ]
        
        print(param)
        
        let url = self.isForUpdate ? URLConstant.updateIncomedetails : URLConstant.usersIncomedetails
        
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
                                 _ = IncomeDetail(data)
                                self.navigationController?.popViewController(animated: true)
                            }else {
                                let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier:  "BankingDetailsViewController") as! BankingDetailsViewController
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
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.getIncomeDetails, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        let income = IncomeDetail(data)
                        self.dataSetup(income)
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
    
    func requestToGetCorrency(completion: @escaping((String)->Void)) {
        
//        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToGetType(URLConstant.getCurrencyDetail) { (response, isSuccess) in
            
//            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        if let currency = data["currency_symbol"] as? String {
                            completion(currency)
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
}
