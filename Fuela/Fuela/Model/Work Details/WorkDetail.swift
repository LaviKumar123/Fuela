//
//  WorkDetail.swift
//  Fuela
//
//  Created by lavi on 14/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import Foundation

struct WorkDetail {
    
    static var shared:WorkDetail!
    
    var data : [String:Any]!
    
    init(_ workData : [String:Any]?) {
        data = workData
        type(of: self).shared = self
    }
    
    var employer: String! {
        get {
            return self.data["employer"] as? String ?? ""
        }
    }
    
    var occupation: String! {
        get {
            return self.data["Occupation"] as? String ?? ""
        }
    }
    
    var experienceYear: String! {
        get {
            return self.data["experience_year"] as? String ?? ""
        }
    }
    var experienceMonth: String! {
           get {
               return self.data["experience_month"] as? String ?? ""
           }
       }
    
    var countryCode: String! {
        get {
            return self.data["country_code"] as? String ?? ""
        }
    }
    
    var contactPerson: String! {
        get {
            return self.data["contact_person"] as? String ?? ""
        }
    }
    
    var address: String! {
        get {
            return self.data["Address"] as? String ?? ""
        }
    }
    
    var contactNumber: String! {
        get {
            return self.data["contact_number"] as? String ?? ""
        }
    }
}
