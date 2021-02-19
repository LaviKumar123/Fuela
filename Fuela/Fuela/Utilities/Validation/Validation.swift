//
//  Validation.swift
//  TowBoss
//
//  Created by lavi on 09/12/19.
//  Copyright © 2019 lavi. All rights reserved.
//

import Foundation
import UIKit

class Validation {
    
    class func isValidName(name:String) -> Bool {
        guard name.count > 2, name.count < 18 else { return false }
        
        let predicateTest = NSPredicate(format: "SELF MATCHES %@", "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$")
        return predicateTest.evaluate(with: name)
    }
    
    class func containsNumbers(_ string : String) -> Bool
    {
        let numberRegEx  = ".*[0-9]+.*"
        let testCase     = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return testCase.evaluate(with: string)
    }
    
    class func isValidURL(_ urlStr: String)-> Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: urlStr, options: [], range: NSRange(location: 0, length: urlStr.endIndex.encodedOffset)) {
            // it is a link, if the match covers the whole string
            return match.range.length == urlStr.endIndex.encodedOffset
        } else {
            return false
        }
    }
    
    class func isValidEmail(_ emailString: String) -> Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        return emailTest.evaluate(with: emailString)
    }
    
    class func isValidZipCode(_ zipcodeString: String) -> Bool {
        
        let zipcodeRegex = "[0-9]{5}"
        
        let zipcodeTest = NSPredicate(format: "SELF MATCHES %@", zipcodeRegex)
        
        return zipcodeTest.evaluate(with: zipcodeString)
    }
    
    class func isValidNumber(_ numberString: String) -> Bool {
        
        let numberRegex = "[0-9]{1,}"
        
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        
        return numberTest.evaluate(with: numberString)
    }
    
    class func isValidPhoneNumber(_ phoneString: String) -> Bool {
        
        let phoneRegex = "[0-9]{10}"
        
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        return phonePredicate.evaluate(with: phoneString)
    }
    
    class func isValidCharacters(_ string: String) -> Bool {
        
        let regex = "[A-Za-z ]{1,}"
        
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return test.evaluate(with: string)
        
    }
    
    
    class func iValidVisaCard(_ cardNumber: String) -> Bool {
        
        let numberRegex = "4[0-9]{6,}"
        
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        
        return numberTest.evaluate(with: cardNumber)
        
    }
    
    class func iValidMasterCard(_ cardNumber: String) -> Bool {
        
        let numberRegex = "5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}"
        
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        
        return numberTest.evaluate(with: cardNumber)
        
    }
    
    class func iValidMaestroCard(_ cardNumber: String) -> Bool {
        
        let numberRegex = "(5[06789]|6)[0-9]{0,}"
        
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        
        return numberTest.evaluate(with: cardNumber)
        
    }
    
    
    
    
    class func CheckcardNumber(_ cardNumber: String) -> String {
        
        let numberRegex = "(5[06789]|6)[0-9]$"
        
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegex)
        
        if numberTest.evaluate(with: cardNumber) {
            
            return "Maestro"
            
        }else {
            
            
            let numberRegex = "^5[1-5]$"
            
            let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegex)
            
            if numberTest.evaluate(with: cardNumber) {
                
                return "Master"
                
            }else {
                
                let checkDouble = "^4[0-9]$"
                
                let numberTest = NSPredicate(format: "SELF MATCHES %@", checkDouble)
                
                if numberTest.evaluate(with: cardNumber){
                    
                    return "Visa"
                    
                }else{
                    
                    return "no"
                }
                
            }
            
            
        }
        
    }
    
    
    class func isPasswordValid(password : String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        
        return passwordTest.evaluate(with: password)
    }
    
    class func isPasswordSame(password: String , confirmPassword : String) -> Bool {
        
        if password == confirmPassword{
            
            return true
            
        }else{
            
            return false
        }
    }
    
    class func isPwdLength(password: String) -> Bool {
        
        if password.count < 6{
            return false
        }else{
            return true
        }
    }
    
    class func isPwdLength(password: String , confirmPassword : String) -> Bool {
        
        if password.count <= 6 && confirmPassword.count <= 6{
            return true
        }else{
            return false
        }
    }
    
    
    class func validate(_ string: String, equalTo match: String) -> Bool {
        
        if (string == match) {
            
            return true
            
        }else {
            
            return false
            
        }
    }
}
