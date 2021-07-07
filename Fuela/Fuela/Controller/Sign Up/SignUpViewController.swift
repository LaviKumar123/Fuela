//
//  SignUpViewController.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import SKCountryPicker

class SignUpViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var fullNameTextField     : UITextField!
    @IBOutlet weak var surnameTextField      : UITextField!
    @IBOutlet weak var emailTextField        : UITextField!
    @IBOutlet weak var genderTextField       : UITextField!
    @IBOutlet weak var dobTextField          : UITextField!
    @IBOutlet weak var address2TextField     : UITextField!
    @IBOutlet weak var pinCodeTextField      : UITextField!
    @IBOutlet weak var phoneTextField        : UITextField!
    @IBOutlet weak var idTypeTextField       : UITextField!
    @IBOutlet weak var idNumberTextField     : UITextField!
    @IBOutlet weak var addressTextField      : UITextField!
    @IBOutlet weak var passwordTextField     : UITextField!
    @IBOutlet weak var confPasswordTextField : UITextField!
    @IBOutlet weak var userImageView         : UIImageView!
    @IBOutlet weak var cameraButton          : UIButton!
    @IBOutlet weak var countryCodeButton     : UIButton!
    
    //MARK:- Image Picker
    var imagePicker         = ImagePicker()
    var isImagePicked       = false
    var countryCode         = "+27"
    var currentValue: String = ""
    private var activeElement: String?

    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        self.requestToCompuscamRegister("242534", surname: "LKM", address: "dfs di dfvidfv")
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        self.dobTextField.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }

    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if self.isValidEntries() {
            self.requestToSignUp()
        }
    }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        self.imagePicker.showImagePicker(self)
        self.imagePicker.delegate = self
    }
    
    @IBAction func pwdHideShowButtonTapped(_ sender: UIButton) {
        self.passwordTextField.isSecureTextEntry = !self.passwordTextField.isSecureTextEntry
    }
    
    @IBAction func confPwdHideShowButtonTapped(_ sender: UIButton) {
        self.confPasswordTextField.isSecureTextEntry = !self.confPasswordTextField.isSecureTextEntry
    }
    
    @IBAction func countryCodeButtonTapped(_ sender: UIButton) {
        
        let countryController = CountryPickerController.presentController(on: self) { (country) in
//            self.countryImageView.image = country.flag
            self.countryCodeButton.setTitle(country.dialingCode, for: .normal)
            self.countryCode = country.dialingCode!
        }
        
        countryController.detailColor = UIColor.red
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
extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.genderTextField) {
            textField.resignFirstResponder()
            self.selectGender(textField)
        }else {
            self.selectIDType(textField)
        }
    }
    
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
        
        let idTypes = ["Identity Document","Passport"/*"Aadhaar", "Pan Card", "Driving Licence"*/]
        
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
        picker.height = 150
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
        
        let idTypes = ["Male", "Female"]
        
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
        picker.height = 150
        picker.show(withAnimation: .FromBottom)
    }
}

//MARK:- Image Picker Delegate
extension SignUpViewController: ImagePickerDelegate {
    func didFinishPickingImage(_ info: AnyObject?) {
        guard (info != nil) else {return}
        
        if let pickedImage = info![UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.userImageView.image = pickedImage
        }else if let pickedImage = info![UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.userImageView.image = pickedImage
        }
        self.isImagePicked = true
    }
}


//MARK:- APIs
extension SignUpViewController {
    
    //MARK:- Validation
    func isValidEntries()-> Bool {
        
        var errorMessage = ""
        
        if self.fullNameTextField.text!.isEmpty {
            errorMessage = "Please enter full name."
        }else if !Validation.isValidName(name: self.fullNameTextField.text!){
            errorMessage = "Please enter valid full name."
        }else if self.surnameTextField.text!.isEmpty {
            errorMessage = "Please enter surname."
        }else if !Validation.isValidName(name: self.surnameTextField.text!){
            errorMessage = "Please enter valid surname."
        }else if self.emailTextField.text!.isEmpty {
            errorMessage = "Please enter your email."
        }else if !Validation.isValidEmail(self.emailTextField.text!){
            errorMessage = "Please enter valid email."
        }else  if self.genderTextField.text!.isEmpty {
            errorMessage = "Please select your gender."
        }else  if self.dobTextField.text!.isEmpty {
            errorMessage = "Please enter your date of birth."
        }else  if self.phoneTextField.text!.isEmpty {
            errorMessage = "Please enter phone number."
        }else if (self.phoneTextField.text!.length < 10)
                    || (self.phoneTextField.text!.length > 15){
            errorMessage = "Phone number length should be between 10 to 15 digits."
        }else  if self.idTypeTextField.text!.isEmpty {
            errorMessage = "Please enter id type."
        }else  if self.idNumberTextField.text!.isEmpty {
            errorMessage = "Please enter id number."
        }else  if self.addressTextField.text!.isEmpty {
            errorMessage = "Please enter address."
        }else  if self.address2TextField.text!.isEmpty {
            errorMessage = "Please enter address 2."
        }else  if self.pinCodeTextField.text!.isEmpty {
            errorMessage = "Please enter pin code."
        }else if self.passwordTextField.text!.isEmpty {
            errorMessage = "Please enter password."
        }else if !Validation.isPwdLength(password: self.passwordTextField.text!)  {
            errorMessage = "Password length should be minimum 6 characters."
        }else if self.confPasswordTextField.text!.isEmpty {
            errorMessage = "Please enter confirm password."
        }else if !Validation.isPwdLength(password: self.confPasswordTextField.text!)  {
            errorMessage = "Confirm Password length should be minimum 6 characters."
        }else if !Validation.isPasswordSame(password: self.passwordTextField.text!, confirmPassword: self.confPasswordTextField.text!){
            errorMessage = "Password doesn't match, please enter same password."
        }else if !self.isImagePicked {
            errorMessage = "Please choose profile image."
        }else {
            return true
        }
        
        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: errorMessage)
        return false
    }
    
    func requestToSignUp() {
        let param = [
            "full_name"         : self.fullNameTextField.text!,
            "surname"           : self.surnameTextField.text!,
            "email"             : self.emailTextField.text!,
            "gender"            : self.genderTextField.text!,
            "dob"               : self.dobTextField.text!,
            "phone"             : self.phoneTextField.text!,
            "id_type"           : self.idTypeTextField.text!,
            "id_number"         : self.idNumberTextField.text!,
            "address"           : self.addressTextField.text!,
            "address2"          : self.address2TextField.text!,
            "pincode"           : self.pinCodeTextField.text!,
            "create_password"   : self.passwordTextField.text!,
            "confirm_password"  : self.confPasswordTextField.text!,
            "country_code"      : self.countryCode
        ]
        
        print(param)
        
        let imageData = self.userImageView.image!.jpeg(.medium)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostWithDataWithoutHeader(URLConstant.signUp, params: param, fileData: imageData, fileKey: "image_url", fileName: self.randomString()) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let data = (response as! [String:Any])["data"] as? [String:Any] {
                        
                        let appUser = AppUser(data)
                        let vc = ACCOUNT_STORYBOARD.instantiateViewController(withIdentifier:  "WorkDetailsViewController") as! WorkDetailsViewController
                        self.navigationController?.pushViewController(vc, animated: true)
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

extension SignUpViewController: XMLParserDelegate {
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

