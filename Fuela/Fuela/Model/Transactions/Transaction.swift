//
//  Transaction.swift
//  Fuela
//
//  Created by APPLE on 02/08/21.
//  Copyright © 2021 lavi. All rights reserved.
//

import Foundation

struct Transaction {
    
    private var data : [String:Any]!
    
    init(_ quotationData : [String:Any]?) {
        self.data = quotationData
    }
    
    var total_balance: String! {
        get {
            return self.data["total_balance"] as? String ?? ""
        }
    }
    
    var runningBalance: String! {
        get {
            return self.data["runningBalance"] as? String ?? ""
        }
    }
    
    var card_balance: String! {
        get {
            return self.data["card_balance"] as? String ?? ""
        }
    }
    
    var wallet_balance: String! {
        get {
            return self.data["wallet_balance"] as? String ?? ""
        }
    }
    
    var transaction_date: String! {
        get {
            return self.data["transaction_date"] as? String ?? ""
        }
    }
    
    var transactionDescription: String! {
        get {
            return self.data["transactionDescription"] as? String ?? ""
        }
    }
    
    var transactionAmount: String! {
        get {
            return self.data["transactionAmount"] as? String ?? ""
        }
    }
    
    var transactionDate: String! {
        get {
            return self.data["transactionDate"] as? String ?? ""
        }
    }
    
    var transactionType: Int! {
        get {
            return self.data["transactionType"] as? Int ?? 0
        }
    }
}

