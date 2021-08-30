//
//  FuelStation.swift
//  Fuela
//
//  Created by APPLE on 03/08/21.
//  Copyright © 2021 lavi. All rights reserved.
//

import Foundation

struct FuelStation {
    
    private var data : [String:Any]!
    
    init(_ quotationData : [String:Any]?) {
        self.data = quotationData
    }
    
    var business_status: String! {
        get {
            return self.data["business_status"] as? String ?? ""
        }
    }
    
    var geometry: [String:Any]! {
        get {
            return self.data["geometry"] as? [String:Any] ?? [:]
        }
    }
    
    var location: [String:Any]! {
        get {
            return self.geometry["location"] as? [String:Any] ?? [:]
        }
    }
    
    var latitude: Double! {
        get {
            if let lat = self.location["lat"] as? String {
                return Double(lat)!
            }else if let lat = self.location["lat"] as? Double {
                return lat
            }else if let lat = self.data["latitude"] as? Double {
                return lat
            }else {
                return 0.0
            }
        }
    }
    
    var longitude: Double! {
        get {
            if let long = self.location["lng"] as? String {
                return Double(long)!
            }else if let long = self.location["lng"] as? Double {
                return long
            }else if let lat = self.data["longitude"] as? Double {
                return lat
            }else {
                return 0.0
            }
        }
    }
    
    var icon: String! {
        get {
            return self.data["icon"] as? String ?? ""
        }
    }
    
    var name: String! {
        get {
            return self.data["name"] as? String ?? ""
        }
    }
    
    var place_id: String! {
        get {
            return self.data["place_id"] as? String ?? ""
        }
    }
    
    var rating: String! {
        get {
            return self.data["rating"] as? String ?? ""
        }
    }
    
    var vicinity: String! {
        get {
            return self.data["vicinity"] as? String ?? self.data["address"] as? String
        }
    }
    
    var user_ratings_total: String! {
        get {
            return self.data["user_ratings_total"] as? String ?? ""
        }
    }
    
    var reference: String! {
        get {
            return self.data["reference"] as? String ?? ""
        }
    }
    
    var phone: String! {
        get {
            return self.data["phone"] as? String ?? ""
        }
    }
}

