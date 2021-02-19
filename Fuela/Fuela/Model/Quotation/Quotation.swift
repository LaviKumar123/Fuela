//
//  Quotation.swift
//  Fuela
//
//  Created by lavi on 20/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import Foundation

struct Quotation {
    
    static var shared : Quotation!
    
    var data : [String:Any]!
    
    init(_ quotationData : [String:Any]?) {
        data = quotationData
        type(of: self).shared = self
    }
    
    var adminValue: String! {
        get {
            return self.data["admin_value"] as? String ?? ""
        }
    }
    
    var interestRate: String! {
        get {
            return self.data["interest_rate"] as? String ?? ""
        }
    }
    
    var userDemand: String! {
        get {
            return self.data["user_demand"] as? String ?? ""
        }
    }
    
    var id: String! {
        get {
            return self.data["id"] as? String ?? ""
        }
    }
}
