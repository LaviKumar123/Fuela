//
//  PersonalDetailsViewController.swift
//  Fuela
//
//  Created by lavi on 07/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import SKCountryPicker

class PersonalDetailsViewController: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var fullNameTextField     : UITextField!
    @IBOutlet weak var surNameTextField      : UITextField!
    @IBOutlet weak var emailTextField        : UITextField!
    @IBOutlet weak var genderTextField       : UITextField!
    @IBOutlet weak var dobTextField          : UITextField!
    @IBOutlet weak var phoneTextField        : UITextField!
    @IBOutlet weak var idTypeTextField       : UITextField!
    @IBOutlet weak var idNumberTextField     : UITextField!
    @IBOutlet weak var addressTextField      : UITextField!
    @IBOutlet weak var address2TextField     : UITextField!
    @IBOutlet weak var pinCodeTextField      : UITextField!
    @IBOutlet weak var countryCodeLabel      : UILabel!
    @IBOutlet weak var countryFlagImageView  : UIImageView!
    
    //MARK:- Variables
    var countryCode  = "+27"
    var selectedGender = ""
    var currentValue: String = ""
    private var activeElement: String?

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode   = UIDatePicker.Mode.date
        datePickerView.maximumDate      = Date()
        self.dobTextField.inputView     = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
        self.dataSetup()
    }
    
    func dataSetup() {
        guard let appUser = AppUser.shared else { return }
        
        let gender = (appUser.gender! == "M") ? "Male" : (appUser.gender! == "O") ? "Other": "Female"
        
        self.fullNameTextField.text = appUser.fullName!
        self.emailTextField.text    = appUser.email!
        self.phoneTextField.text    = appUser.phone!
        self.surNameTextField.text  = appUser.surname!
        self.selectedGender         = appUser.gender!
        self.genderTextField.text   = gender
        self.dobTextField.text      = appUser.dob!
        self.idTypeTextField.text   = appUser.idType!
        self.idNumberTextField.text = appUser.idNumber!
        self.addressTextField.text  = appUser.address
        self.address2TextField.text = appUser.address2
        self.pinCodeTextField.text  = appUser.pincode!
        self.countryCode            = appUser.countryCode
        self.countryCodeLabel.text  = self.countryCode
        self.countryFlagImageView.image = CountryManager.shared.country(withDigitCode: self.countryCode)?.flag
    }
        
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countryCodeButtonTapped(_ sender: UIButton) {
        
//        let countryController = CountryPickerController.presentController(on: self) { (country) in
//            self.countryCode = country.dialingCode!
//            self.countryCodeLabel.text  = self.countryCode
//            let flag = country.flag
//            self.countryFlagImageView.image = flag
//        }
//        
//        countryController.detailColor = UIColor.red
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        if self.isValidEntries() {
            self.requestToUpdate()
        }
    }
    
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.selectGender(self.genderTextField)
    }
    
    @IBAction func idTypeButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        self.selectIDType(self.idTypeTextField)
    }
    
    //TODO:- Date Picker
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.dobTextField.text = dateFormatter.string(from: sender.date)
    }
}

//MARK:- Text Field Delegate
extension PersonalDetailsViewController: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if (textField == self.genderTextField) {
////            textField.resignFirstResponder()
//            self.selectGender(textField)
//        }else {
//            self.selectIDType(textField)
//        }
//    }
    
    //TODO:- State Picker
    func selectIDType(_ sender: UITextField) {
        
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Identity Document",
            titleFont           : UIFont.boldSystemFont(ofSize: 16),
            titleTextColor      : .white,
            titleBackground     : sender.backgroundColor,
            searchBarFont       : UIFont.systemFont(ofSize: 16),
            searchBarPlaceholder: "Select Identity Document",
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
        
        let idTypes = ["Smart Id Card","Passport"/*"Aadhaar", "Pan Card", "Driving Licence"*/]
        
        let picker = YBTextPicker.init(with: idTypes , appearance: redAppearance,
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
        
        picker.leftPadding = 20
        picker.rightPadding = 20
        picker.height = 200
        picker.preSelectedValues = [sender.text!]
        picker.setupLayout()
        picker.show(withAnimation: .FromBottom)
    }
    
    //TODO:- Gender Picker
    func selectGender(_ sender: UITextField) {
        
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select Your Gender",
            titleFont           : UIFont.boldSystemFont(ofSize: 16),
            titleTextColor      : .white,
            titleBackground     : sender.backgroundColor,
            searchBarFont       : UIFont.systemFont(ofSize: 16),
            searchBarPlaceholder: "Select Your Gender",
            closeButtonTitle    : "Cancel",
            closeButtonColor    : .darkGray,
            closeButtonFont     : UIFont.systemFont(ofSize: 16),
            doneButtonTitle     : "Done",
            doneButtonColor     : sender.backgroundColor,
            doneButtonFont      : UIFont.boldSystemFont(ofSize: 16),
            checkMarkPosition   : .Right,
            itemColor           : .black,
            itemFont            : UIFont.systemFont(ofSize: 20)
        )
        
        let idTypes = ["Male", "Female", "Other"]
        
        let picker = YBTextPicker.init(with: idTypes , appearance: redAppearance,
                                       onCompletion: { (selectedIndexes, selectedValues) in
                                        if let selectedValue = selectedValues.first{
                                            sender.text = selectedValue
                                            self.selectedGender = (selectedValue == "Male") ? "M" : (selectedValue == "Female") ? "F" : "O"
                                            sender.resignFirstResponder()
                                        }else{
                                        }
                                       },
                                       onCancel: {
                                        print("Cancelled")
                                       }
        )
        
        picker.leftPadding = 20
        picker.rightPadding = 20
        picker.height = 250
        picker.preSelectedValues = [sender.text!]
        picker.setupLayout()
        picker.show(withAnimation: .FromBottom)
    }
}

//MARK:- APIs
extension PersonalDetailsViewController {
    
    //MARK:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.fullNameTextField.text!.isEmpty {
            errorMessage = "Please enter first name."
//        }else if !Validation.isValidName(name: self.fullNameTextField.text!){
//            errorMessage = "Please enter valid full name."
        }else if self.surNameTextField.text!.isEmpty {
            errorMessage = "Please enter last name."
//        }else if !Validation.isValidName(name: self.surNameTextField.text!){
//            errorMessage = "Please enter valid last name."
        }else if self.emailTextField.text!.isEmpty {
            errorMessage = "Please enter your email."
//        }else if !Validation.isValidEmail(self.emailTextField.text!){
//            errorMessage = "Please enter valid email."
        }else  if self.genderTextField.text!.isEmpty {
            errorMessage = "Please select your gender."
        }else  if self.dobTextField.text!.isEmpty {
            errorMessage = "Please enter your date of birth."
        }else  if self.phoneTextField.text!.isEmpty {
            errorMessage = "Please enter contact number."
        }else if (self.phoneTextField.text!.length < 9) || (self.phoneTextField.text!.length > 9){
            errorMessage = "Contact number length should be 9 digits."
        }else  if self.idTypeTextField.text!.isEmpty {
            errorMessage = "Please enter id type."
        }else  if self.idNumberTextField.text!.isEmpty {
            errorMessage = "Please enter id number."
        }else  if self.idNumberTextField.text!.isEmpty {
            errorMessage = "Please enter address."
//        }else  if self.address2TextField.text!.isEmpty {
//            errorMessage = "Please enter address 2."
        }else  if self.pinCodeTextField.text!.isEmpty {
            errorMessage = "Please enter zip code."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
    
    func requestToUpdate() {
        let param = [
            "user_id"   : AppUser.shared.id!,
            "full_name" : self.fullNameTextField.text!,
            "surname"   : self.surNameTextField.text!,
            "gender"    : self.selectedGender,
            "dob"       : self.dobTextField.text!,
            "email"     : self.emailTextField.text!,
            "phone"     : self.phoneTextField.text!,
            "id_type"   : self.idTypeTextField.text!,
            "id_number" : self.idNumberTextField.text!,
            "address"   : self.addressTextField.text!,
            "address2"  : self.address2TextField.text!,
            "pincode"   : self.pinCodeTextField.text!,
            "country_code": self.countryCode
        ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostWithData(URLConstant.updatePersonalDetails, params: param, header: [:], fileData: nil, fileKey: "Image", fileName: "sdfjkb") { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        
                        let message = (response as! [String:Any])["msg"] as? String ?? ""
                        customSuccessPopUp(textToDisplay: message)
                        
                        let appUser = AppUser(data)
                        
                        let archiveData = try? NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
                        UserDefaults.standard.set(archiveData, forKey: "Loggin User")
                        
                        self.navigationController?.popViewController(animated: true)
                    }
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

extension PersonalDetailsViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.activeElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.activeElement == "retData" {
            self.currentValue += string
            print(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if self.activeElement == "retData" {
        }
    }
    
    // Just in case, if there's an error, report it. (We don't want to fly blind here.)
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
        self.currentValue = ""
    }
}


