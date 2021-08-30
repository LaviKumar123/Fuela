//
//  Constant.swift
//  Tripp
//
//  Created by lavi on 25/11/19.
//  Copyright © 2019 Alcax. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CRNotifications

let MAIN_STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
let HOME_STORYBOARD = UIStoryboard(name: "Home", bundle: nil)
let ACCOUNT_STORYBOARD = UIStoryboard(name: "Account", bundle: nil)
let APP_DELEGATE    = UIApplication.shared.delegate as! AppDelegate
let SCENE_DELEGATE  = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

let MAP_API_KEY = "AIzaSyBWGnEZ9FPPQ0EpsyIFveyWz1b0pMzz7jU"

let WINDOW_WIDTH    = UIScreen.main.bounds.width
let WINDOW_HEIGHT   = UIScreen.main.bounds.height

var CURRENT_LOCATION : (latitude: Double, longitude: Double)?
var CURRENT_PLACEMARK:CLPlacemark?

var VIEW_ALL_CATEGORY_PRODUCTS : Category!

var CURRENT_ORDER_ID = 0

var FCM_TOKEN = "sdfgdsgdfsgdsfgddsfdsf"
var DEVICE_INFO = [
                        "AppVersion":Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0",
                        "Manufacturer":"Apple",
                        "ModelNo":UIDevice.current.model,
                        "OS_Version":UIDevice.current.systemVersion
                    ]


func getVersion() -> String {
    guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
        return "no version info"
    }
    return version
}

//MARK:- CRNotifications

func customWelcomePopUp(textToDisplay : String){
    CRNotifications.showNotification(type: CRNotifications.success, title: "Card Cavern", message: textToDisplay, dismissDelay: 3)
}

func customErrorPopUp(textToDisplay : String){
    
    if textToDisplay == "Unauthenticated." {
        CRNotifications.showNotification(type: CRNotifications.error, title: "Card Cavern", message: "User doesn’t exist.", dismissDelay: 3)
//        UserDefaults.standard.removeObject(forKey: "Loggin User")
//        let loginVc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//        APP_DELEGATE.navigationController.setViewControllers([loginVc], animated: false)
    }else {
         CRNotifications.showNotification(type: CRNotifications.error, title: "Card Cavern", message: textToDisplay, dismissDelay: 3)
    }
}

func customSuccessPopUp(textToDisplay : String){
    CRNotifications.showNotification(type: CRNotifications.success, title: "Card Cavern", message: textToDisplay, dismissDelay: 3)
}

func customErrorPopUpWithoutTitle(textToDisplay : String){
    CRNotifications.showNotification(type: CRNotifications.error, title: "", message: textToDisplay, dismissDelay: 3)
}

func customInfoPopUpAlert(textToDisplay : String){
    CRNotifications.showNotification(type: CRNotifications.info, title: "", message: textToDisplay, dismissDelay: 5)
}
