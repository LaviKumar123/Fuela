//
//  AppUser.swift
//  Fuela
//
//  Created by lavi on 13/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//


import Foundation

class AppUser {
    
    static var shared: AppUser!
    
    var data : [String:Any]!
    
    init(_ userData : [String:Any]?) {
        data = userData
        type(of: self).shared = self
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = AppUser(self.data)
        return copy
    }
    
    var email: String! {
        get {
            return self.data["email"] as? String ?? ""
        }
    }
    
    var isBlock: String! {
        get {
            return self.data["is_block"] as? String ?? ""
        }
    }
    
    var isCardAdded: Bool! {
        get {
            return self.data["is_card"] as? Bool ?? false
        }
    }
    
    var isUserAccepted: String! {
        get {
            return self.data["user_status"] as? String ?? ""
        }
    }
    
    var cardNumber: String! {
        get {
            return self.data["card_no"] as? String ?? ""
        }
    }
    
    var isForgot: String! {
        get {
            return self.data["is_forgot"] as? String ?? ""
        }
    }
    
    var profileURL: String! {
        get {
            return self.data["image_url"] as? String ?? ""
        }
    }
    
    var address: String! {
        get {
            return self.data["address"] as? String ?? ""
        }
    }
    
    var currency: String! {
        get {
            return self.data["currency"] as? String ?? ""
        }
    }
    
    var step : Int! {
        get  {
            if let id = self.data["step"] as? Int {
                return id
            }else if let id = self.data["step"] as? String {
                return Int(id)
            }else {
                return 0
            }
        }
    }
    
    var idType: String! {
        get {
         return self.data["id_type"] as? String ?? ""
        }
    }
    
    var idNumber: String! {
           get {
            return self.data["id_number"] as? String ?? ""
           }
       }
    
    var fullName: String! {
        get {
            return self.data["name"] as? String ?? ""
        }
    }
    
    var surname: String! {
        get {
            return self.data["surname"] as? String ?? ""
        }
    }
    
    var phone: String! {
        get {
            return self.data["mobile"] as? String ?? ""
        }
    }
    
    var gender: String! {
        get {
            return self.data["gender"] as? String ?? ""
        }
    }
    
    var pincode: String! {
        get {
            return self.data["pincode"] as? String ?? ""
        }
    }
    
    var address2: String! {
        get {
            return self.data["address2"] as? String ?? ""
        }
    }
    
    var dob: String! {
        get {
            return self.data["dob"] as? String ?? ""
        }
    }
    
    var countryCode: String! {
        get {
            return self.data["country_code"] as? String ?? ""
        }
    }
    
    var id: String! {
        get {
            if let id = self.data["user_id"] as? Int {
                return "\(id)"
            }else if let id = self.data["user_id"] as? String {
                return id
            }else if let id = self.data["id"] as? Int {
                return "\(id)"
            }else if let id = self.data["id"] as? String {
                return id
            }else {
                return "0"
            }
        }
    }
}
