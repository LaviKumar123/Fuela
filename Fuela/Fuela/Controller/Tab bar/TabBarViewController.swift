//
//  TabBarViewController.swift
//  GameChallenger
//
//  Created by lavi on 01/04/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import HTMLReader

class TabBarViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var titleLabel: [UILabel]!
    @IBOutlet weak var addNewButton: UIButton!
    
    //MARK:- Variables
    var homeViewController         : HomeViewController!
    var notificationViewController : NotificationViewController!
    var historyViewController      : HistoryViewController!
    var accountViewController      : AccountViewController!
    
    var viewControllers : [UIViewController]!
    var selectedIndex   : Int = 0
    
    var selectedIcons   : [UIImage] = [#imageLiteral(resourceName: "home red"),#imageLiteral(resourceName: "Notification Red"),#imageLiteral(resourceName: "History Red"),#imageLiteral(resourceName: "Account red")]
    var unselectedIcons : [UIImage] = [#imageLiteral(resourceName: "home grey"),#imageLiteral(resourceName: "Notification Grey"),#imageLiteral(resourceName: "History Grey"),#imageLiteral(resourceName: "Account Grey")]
    
   
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.configureViewControllers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func configureViewControllers() {
        
        self.homeViewController         = HOME_STORYBOARD.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        self.notificationViewController  = HOME_STORYBOARD.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController
        self.historyViewController       = HOME_STORYBOARD.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController
        self.accountViewController       = HOME_STORYBOARD.instantiateViewController(withIdentifier: "AccountViewController") as? AccountViewController
        
        self.viewControllers             = [homeViewController,notificationViewController,historyViewController,accountViewController]
        buttons[selectedIndex].isSelected   = true
        
        self.barButtonTapped(buttons[selectedIndex])
    }
    
    //MARK:- Button Action
    @IBAction func barButtonTapped(_ sender: UIButton) {
        self.configureSelectedViewController(sender)
        self.manageSelectedButton(sender)
    }
    
    @IBAction func addNewButtonTapped(_ sender: UIButton) {
        BottomPopupView.show(self)
    }
    
    func manageSelectedButton(_ sender: UIButton) {
        for i in 0...3 {
            if self.buttons[i] == sender || sender.tag == i {
                self.buttons[i].setImage(self.selectedIcons[sender.tag], for: .normal)
                self.titleLabel[i].textColor = UIColor(red: 197/255, green: 0, blue: 0, alpha: 1.0)
            }else {
                self.buttons[i].setImage(self.unselectedIcons[i], for: .normal)
                self.titleLabel[i].textColor = UIColor.darkGray
            }
        }
    }
    
    func configureSelectedViewController(_ sender: UIButton) {
        
        let previousIndex = selectedIndex
        self.selectedIndex = sender.tag
        buttons[previousIndex].isSelected = false
        let previousVC = self.viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        sender.isSelected = true
        
        let vc = viewControllers[selectedIndex]
        
        self.addChild(vc)
        vc.view.frame = contentView.bounds
        self.contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        self.tabBarView.superview?.bringSubviewToFront(self.tabBarView)
        self.addNewButton.superview?.bringSubviewToFront(self.addNewButton)
    }
}
