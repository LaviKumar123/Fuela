//
//  Rewards.swift
//  Fuela
//
//  Created by APPLE on 30/08/21.
//  Copyright © 2021 lavi. All rights reserved.
//

import Foundation

struct Reward {
    
    static var shared : Reward!
    
    var data : [String:Any]!
    
    init(_ dict : [String:Any]?) {
        data = dict
        type(of: self).shared = self
    }
    
    var user_id: String! {
        get {
            return self.data["user_id"] as? String ?? ""
        }
    }
    
    var id: String! {
        get {
            return self.data["id"] as? String ?? ""
        }
    }
    
    var reward_amt: String! {
        get {
            return self.data["reward_amt"] as? String ?? ""
        }
    }
    
    var currency: String! {
        get {
            return self.data["currency"] as? String ?? ""
        }
    }
    
    var status: String! {
        get {
            return self.data["status"] as? String ?? ""
        }
    }
    
    var button_status: Bool! {
        get {
            return self.data["button_status"] as? Bool ?? false
        }
    }
    
    
    var reward_request_amt: String! {
        get {
            return self.data["reward_request_amt"] as? String ?? ""
        }
    }
    
    var uid: String! {
        get {
            return self.data["uid"] as? String ?? ""
        }
    }
    
    var admin_status: String! {
        get {
            return self.data["admin_status"] as? String ?? ""
        }
    }
    
    var reward_date: String! {
        get {
            return self.data["reward_date"] as? String ?? ""
        }
    }
    
    var title: String! {
        get {
            return self.data["title"] as? String ?? ""
        }
    }
    
    var image_url: String! {
        get {
            return self.data["image_url"] as? String ?? ""
        }
    }
}

