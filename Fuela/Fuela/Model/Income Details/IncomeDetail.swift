//
//  IncomeDetail.swift
//  Fuela
//
//  Created by lavi on 14/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import Foundation

struct IncomeDetail {
    
    static var shared : IncomeDetail!
    
    var data : [String:Any]!
    
    init(_ workData : [String:Any]?) {
        data = workData
        type(of: self).shared = self
    }
    
    var sourceIncome: String! {
        get {
            return self.data["source_income"] as? String ?? ""
        }
    }
    
    var salaryDate: String! {
        get {
            return self.data["salary_date"] as? String ?? ""
        }
    }
    
    var additionalIncome: String! {
        get {
            return self.data["additional_income"] as? String ?? ""
        }
    }
    
    var totalIncome: String! {
        get {
            return self.data["total_income"] as? String ?? ""
        }
    }
    
    var totalExpenses: String! {
        get {
            return self.data["total_expenses"] as? String ?? ""
        }
    }
    
    var netIncome: String! {
        get {
            return self.data["net_income"] as? String ?? ""
        }
    }
}
