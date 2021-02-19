//
//  StationViewController.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import MapKit

class StationViewController: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var stationTableView: UITableView!
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.headerViewSetup()
    }
    
    func headerViewSetup() {
        let nibViews = Bundle.main.loadNibNamed("StationMapView", owner: self, options: nil)
        let stretchyHeaderView = nibViews!.first as! StationMapView
        self.stationTableView.addSubview(stretchyHeaderView)
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

//MARK:- Table View Dlegate And Data Source
extension StationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationTableViewCell", for: indexPath) as! StationTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = HOME_STORYBOARD.instantiateViewController(identifier: "StationDetailsViewController") as! StationDetailsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
