//
//  Notification.swift
//  Fuela
//
//  Created by APPLE on 31/08/21.
//  Copyright © 2021 lavi. All rights reserved.
//

import Foundation

struct NotificationInfo {
    
    static var shared : NotificationInfo!
    
    var data : [String:Any]!
    
    init(_ dict : [String:Any]?) {
        data = dict
        type(of: self).shared = self
    }
    
    var message: String! {
        get {
            return self.data["message"] as? String ?? ""
        }
    }
    
    var notify_id: String! {
        get {
            return self.data["notify_id"] as? String ?? ""
        }
    }
    
    var status: String! {
        get {
            return self.data["status"] as? String ?? ""
        }
    }
    
    var name: String! {
        get {
            return self.data["name"] as? String ?? ""
        }
    }
    
    var surname: String! {
        get {
            return self.data["surname"] as? String ?? ""
        }
    }
    
    var title: String! {
        get {
            return self.data["title"] as? String ?? ""
        }
    }
    
    var user_id: Int! {
        get {
            return self.data["user_id"] as? Int ?? 0
        }
    }
    
    var image_url: String! {
        get {
            return self.data["image_url"] as? String ?? ""
        }
    }
}
