//
//  WorkDetailsViewController.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import SKCountryPicker

class WorkDetailsViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var employerTextField         : UITextField!
    @IBOutlet weak var occupationTextField       : UITextField!
    @IBOutlet weak var yearOfExpTextField        : UITextField!
    @IBOutlet weak var monthOfExpTextField       : UITextField!
    @IBOutlet weak var addressTextField          : UITextField!
    @IBOutlet weak var contactPersonTextField    : UITextField!
    @IBOutlet weak var contactNumberTextField    : UITextField!
    @IBOutlet weak var countryCodeLabel          : UILabel!
    @IBOutlet weak var countryFlagImageView      : UIImageView!
    
    @IBOutlet weak var updateButtonView : UIView!
    @IBOutlet weak var nextButtton      : UIButton!
    
    //MARK:- Variables
    var isForUpdate = false
    var isFromRegistration = false
    var countryCode  = "+27"
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateButtonView.isHidden = !self.isForUpdate
        self.nextButtton.isHidden      = self.isForUpdate
        
        self.countryFlagImageView.image = CountryManager.shared.country(withDigitCode: "+27")?.flag
        
        if self.isForUpdate {
            if let work = WorkDetail.shared {
                self.dataSetup(work)
            }else {
                self.requestToGetDetails()
            }
        }
    }
    
    func dataSetup(_ work: WorkDetail) {
        
        self.employerTextField.text         = work.employer
        self.occupationTextField.text       = work.occupation
        self.yearOfExpTextField.text        = work.experienceYear + " Year"
        self.addressTextField.text          = work.address
        self.contactNumberTextField.text    = work.contactNumber
        self.contactPersonTextField.text    = work.contactPerson
        self.countryCode                    = work.countryCode
        self.countryFlagImageView.image = CountryManager.shared.country(withDigitCode: self.countryCode)?.flag
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
    
    @IBAction func yearOfExpButtonTapped(_ sender: UIButton) {
        let yearArr = [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12",
                        "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24",
                        "25", "26", "27", "28", "29", "30"]
        self.selectExperience(self.yearOfExpTextField, stringArr: yearArr, title: "Select Year Of Experience")
    }
    
    @IBAction func countryCodeButtonTapped(_ sender: UIButton) {
        
//        let countryController = CountryPickerController.presentController(on: self) { (country) in
//
//            self.countryCode = country.dialingCode!
//            self.countryCodeLabel.text  = self.countryCode
//            let flag = country.flag
//            self.countryFlagImageView.image = flag
//        }
//
//        countryController.detailColor = UIColor.red
    }
}

//MARK:- Text Field Delegate
extension WorkDetailsViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == self.yearOfExpTextField {
//            let yearArr = ["1 Year","2 Year","3 Year","4 Year","5 Year","6 Year","7 Year","8 Year","9 Year","10 Year","11 Year","12 Year","13 Year","14 Year","15 Year","16 Year","17 Year","18 Year","19 Year","20 Year"]
//            self.selectExperience(textField, stringArr: yearArr, title: "Select Year Of Experience")
//        }else if textField == self.monthOfExpTextField {
//            let monthArr = ["1 Month","2 Month","3 Month","4 Month","5 Month","6 Month","7 Month","8 Month","9 Month","10 Month","11 Month","12 Month"]
//            self.selectExperience(textField, stringArr: monthArr, title: "Select Month Of Experience")
//        }
//    }
    
    //TODO:- State Picker
    func selectExperience(_ sender: UITextField, stringArr: [String], title: String) {
        
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
                                            sender.text = selectedValue + " Year"
                                            sender.resignFirstResponder()
                                        }else{
                                        }
        },
                                       onCancel: {
                                        print("Cancelled")
        }
        )
        
        picker.leftPadding = 50
        picker.rightPadding = 50
        picker.height = 350
        picker.preSelectedValues = [sender.text!.replacingOccurrences(of: " Year", with: "")]
        picker.setupLayout()
        picker.show(withAnimation: .FromBottom)
    }
}


//MARK:- APIs
extension WorkDetailsViewController {
    
    //TODO:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.employerTextField.text!.isEmpty {
            errorMessage = "Please enter employer."
        }else  if self.occupationTextField.text!.isEmpty {
            errorMessage = "Please enter occupation."
        }else  if self.yearOfExpTextField.text!.isEmpty {
            errorMessage = "Please enter year of experience."
//        }else  if self.monthOfExpTextField.text!.isEmpty {
//            errorMessage = "Please enter month of experience."
        }else  if self.addressTextField.text!.isEmpty {
            errorMessage = "Please enter address."
        }else  if self.contactPersonTextField.text!.isEmpty {
            errorMessage = "Please enter contact person."
        }else if !Validation.isValidName(name: self.contactPersonTextField.text!){
            errorMessage = "Contact person should contains only alphabets."
        }else  if self.contactNumberTextField.text!.isEmpty {
            errorMessage = "Please enter contact number."
        }else if (self.contactNumberTextField.text!.length < 9) || (self.contactNumberTextField.text!.length > 9){
            errorMessage = "Contact number length should be 9 digits."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
    
    //TODO:- Request
    func requestToSubmitDetails() {
        let param = [
                        "user_id"           :AppUser.shared.id!,
                        "employer"          :self.employerTextField.text!,
                        "occupation"        :self.occupationTextField.text!,
                        "experience"        :self.yearOfExpTextField.text!.replacingOccurrences(of: " Year", with: ""),
//                        "experience_month"  :self.monthOfExpTextField.text!.replacingOccurrences(of: " Month", with: ""),
                        "address"           :self.addressTextField.text!,
                        "contact_person"    :self.contactPersonTextField.text!,
                        "contact_number"    :self.contactNumberTextField.text!,
                        "country_code"      :self.countryCode
                    ]
        
        print(param)
        
        let url = self.isForUpdate ? URLConstant.updateWorkDetails : URLConstant.userWorkDetail
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostWithData(url, params: param, header: [:], fileData: nil, fileKey: "Image", fileName: "sdfjkb")  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        
                       let message = (response as! [String:Any])["msg"] as? String ?? ""
                        AlertView.show(self, image: #imageLiteral(resourceName: "Account verification"), message: message)
                        
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                           if self.isForUpdate {
                                 _ = WorkDetail(data)
                                self.navigationController?.popViewController(animated: true)
                            }else {
                                let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier:  "IncomeDetailsViewController") as! IncomeDetailsViewController
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
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.getWorkDetails, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                                                
                        let work = WorkDetail(data)
                        self.dataSetup(work)
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
