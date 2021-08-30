//
//  SceneDelegate.swift
//  Fuela
//
//  Created by lavi on 06/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    //MARK:- Variable
    var window: UIWindow?
    var navigationController = UINavigationController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        self.defaultScreenSetup()
        self.setupStatusBar()
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func defaultScreenSetup() {
        
        self.navigationController.navigationBar.isHidden = true
        
        if let userArchived = UserDefaults.standard.value(forKey: "Loggin User") as? Data {
            if let userData = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userArchived) as? [String: Any] {
                
                _ =  AppUser(userData)
                
                let tabBarVC = HOME_STORYBOARD.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                
                self.navigationController.setViewControllers([tabBarVC], animated: false)
            }
        } else {
            let vc = MAIN_STORYBOARD.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            self.navigationController.setViewControllers([vc], animated: true)
        }
        
        self.window?.rootViewController = self.navigationController
    }

    
    func setupStatusBar() {
        
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIImageView()
            statusbarView.image = #imageLiteral(resourceName: "Large Button")
            statusbarView.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 25/255, alpha: 1.0)
            self.navigationController.view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: self.navigationController.view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: self.navigationController.view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: self.navigationController.view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor(red: 255/255, green: 85/255, blue: 25/255, alpha: 1.0)
        }
    }
}

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent//topViewController?.preferredStatusBarStyle ?? .default
   }
}
