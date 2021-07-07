//
//  BankDetail.swift
//  Fuela
//
//  Created by lavi on 14/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import Foundation

struct BankDetail {
    
    static var shared : BankDetail!
    
    var data : [String:Any]!
    
    init(_ workData : [String:Any]?) {
        data = workData
        type(of: self).shared = self
    }
    
    var accountHolderName: String! {
        get {
            return self.data["account_holder_name"] as? String ?? ""
        }
    }
    
    var bankName: String! {
        get {
            return self.data["bank_name"] as? String ?? ""
        }
    }
    
    var accountNumber: String! {
        get {
            return self.data["account_number"] as? String ?? ""
        }
    }
    
    var accountType: String! {
        get {
            return self.data["account_type"] as? String ?? ""
        }
    }
    
    var branchCode: String! {
        get {
            return self.data["branch_code"] as? String ?? ""
        }
    }
    
    var branchName: String! {
        get {
            return self.data["branch_name"] as? String ?? ""
        }
    }
}
