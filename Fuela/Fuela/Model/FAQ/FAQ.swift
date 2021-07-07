//
//  FAQ.swift
//  Fuela
//
//  Created by lavi on 14/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import Foundation

struct FAQ {
    
    static var shared : FAQ!
    
    var data : [String:Any]!
    
    init(_ workData : [String:Any]?) {
        data = workData
        type(of: self).shared = self
    }
    
    var heading: String! {
        get {
            return self.data["heading"] as? String ?? self.data["question"] as? String ?? ""
        }
    }
    
    var message: String! {
        get {
            return self.data["message"] as? String ?? self.data["answers"] as? String ?? ""
        }
    }
    
    var id: String! {
        get {
            return self.data["id"] as? String ?? ""
        }
    }
}
