//
//  AppDelegate.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    //MARK:- Variable
    var window: UIWindow?
    var navigationController = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        registerForRemoteNotification()
        
        GMSServices.provideAPIKey(MAP_API_KEY)
        GMSPlacesClient.provideAPIKey(MAP_API_KEY)
        
        // Use Firebase library to configure APIs
        
//        self.noificationSetup(application)
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

//MARK:- Notification Setup

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
//    func noificationSetup(_ application: UIApplication) {
//
//
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
//
//        //firebase setup
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        Messaging.messaging().isAutoInitEnabled = true
//
//    }
    
    func registerForRemoteNotification() {
        // For iOS 10 display notification (sent via APNS)
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        // For iOS 10 data message sent via FCM
        
        Messaging.messaging().delegate = self
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
//        AlertView.show(self.navigationController, image: #imageLiteral(resourceName: "Account verification"), message: "\(userInfo)")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let userInfo   = response.notification.request.content.userInfo as? [String:Any]
   //           ,let dataString = userInfo["gcm.notification.roomInfo"] as? String,
   //           let dataInfo   = self.convertToDictionary(text: dataString){
        {
            print(userInfo)
//            AlertView.show(self.navigationController, image: #imageLiteral(resourceName: "Account verification"), message: "\(userInfo)")
        }
        
        completionHandler()
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let userInfo   = notification.request.content.userInfo as? [String:Any]
//           ,let dataString = userInfo["gcm.notification.roomInfo"] as? String,
//           let dataInfo   = self.convertToDictionary(text: dataString)
           {
            
//            AlertView.show(self.navigationController, image: #imageLiteral(resourceName: "Account verification"), message: "\(userInfo)")
        }
        completionHandler([.alert,.sound,.badge])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print(deviceToken)
        Messaging.messaging().apnsToken = deviceToken

    }
    
    //MARK:- Custom Methods
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token: \(fcmToken)")
        
        if let token = Messaging.messaging().fcmToken {
            UserDefaults.standard.setValue(token, forKey: "FCMToken")
        }else{
            
        }
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
