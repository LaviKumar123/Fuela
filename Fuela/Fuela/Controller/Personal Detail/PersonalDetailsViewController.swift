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
    @IBOutlet weak var emailTextField        : UITextField!
    @IBOutlet weak var phoneTextField        : UITextField!
    @IBOutlet weak var idTypeTextField       : UITextField!
    @IBOutlet weak var idNumberTextField     : UITextField!
    @IBOutlet weak var addressTextField      : UITextField!
    @IBOutlet weak var countryCodeButton     : UIButton!
    
    //MARK:- Variables
    var countryCode  = "+27"

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSetup()
    }
    
    func dataSetup() {
        guard let appUser = AppUser.shared else { return }
        
        self.fullNameTextField.text = appUser.fullName!
        self.emailTextField.text    = appUser.email!
        self.phoneTextField.text    = appUser.phone!
        self.idTypeTextField.text   = appUser.idType!
        self.idNumberTextField.text = appUser.idNumber!
        self.addressTextField.text  = appUser.address
        self.countryCode            = "+" + appUser.countryCode
        self.countryCodeButton.setTitle(self.countryCode, for: .normal)
    }

    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countryCodeButtonTapped(_ sender: UIButton) {
        
        let countryController = CountryPickerController.presentController(on: self) { (country) in
            
            //            self.countryImageView.image = country.flag
            self.countryCodeButton.setTitle(country.dialingCode, for: .normal)
            self.countryCode = country.dialingCode!
        }
        
        countryController.detailColor = UIColor.red
    }
    
    @IBAction func updateButtonTapped(_ sender: UIButton) {
        if self.isValidEntries() {
            self.requestToUpdate()
        }
    }
}

//MARK:- Text Field Delegate
extension PersonalDetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectIDType(textField)
    }
    
    //TODO:- State Picker
    func selectIDType(_ sender: UITextField) {
        
        let redAppearance = YBTextPickerAppearanceManager.init(
            pickerTitle         : "Select ID Type",
            titleFont           : UIFont.boldSystemFont(ofSize: 16),
            titleTextColor      : .white,
            titleBackground     : sender.backgroundColor,
            searchBarFont       : UIFont.systemFont(ofSize: 16),
            searchBarPlaceholder: "Select ID Type",
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
        
        let idTypes = ["Aadhaar", "Pan Card", "Driving Licence"]
        
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
        picker.height = 250
        picker.show(withAnimation: .FromBottom)
    }
}

//MARK:- APIs
extension PersonalDetailsViewController {
    
    //MARK:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.fullNameTextField.text!.isEmpty {
            errorMessage = "Please enter full name."
        }else if !Validation.isValidName(name: self.fullNameTextField.text!){
            errorMessage = "Please enter valid full name."
        }else if self.emailTextField.text!.isEmpty {
            errorMessage = "Please enter your email."
        }else if !Validation.isValidEmail(self.emailTextField.text!){
            errorMessage = "Please enter valid email."
        }else  if self.phoneTextField.text!.isEmpty {
            errorMessage = "Please enter phone number."
        }else if (self.phoneTextField.text!.length < 10) || (self.phoneTextField.text!.length > 15){
            errorMessage = "Phone number length should be between 10 to 15 digits."
        }else  if self.idTypeTextField.text!.isEmpty {
            errorMessage = "Please enter id type."
        }else  if self.idNumberTextField.text!.isEmpty {
            errorMessage = "Please enter id number."
        }else  if self.idNumberTextField.text!.isEmpty {
            errorMessage = "Please enter address."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
    
    func requestToUpdate() {
        let param = [
            "user_id"   : AppUser.shared.id!,
            "full_name" :self.fullNameTextField.text!,
            "email"     :self.emailTextField.text!,
            "phone"     :self.phoneTextField.text!,
            "id_type"   :self.idTypeTextField.text!,
            "id_number" :self.idNumberTextField.text!,
            "address"   :self.addressTextField.text!,
            "country_code": self.countryCode
        ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.updatePersonalDetails, param, header: [:])  { (response, isSuccess) in
            
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
