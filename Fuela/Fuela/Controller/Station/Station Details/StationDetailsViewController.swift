//
//  StationDetailsViewController.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class StationDetailsViewController: UIViewController {
    
    @IBOutlet weak var stationTableView: UITableView!
    
    //MARK:- Variable
    var fuelStation: FuelStation!
    var banners: [UIImage] = [#imageLiteral(resourceName: "banner1"), #imageLiteral(resourceName: "banner2")]
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.headerViewSetup()
    }
    
    func headerViewSetup() {
        let nibViews = Bundle.main.loadNibNamed("StationMapView", owner: self, options: nil)
        let stretchyHeaderView = nibViews!.first as! StationMapView
        stretchyHeaderView.mapViewSetup([self.fuelStation])
        self.stationTableView.addSubview(stretchyHeaderView)
    }
    
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
   
}

//MARK:- Table View Dlegate And Data Source
extension StationDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationDetailsTableViewCell") as! StationDetailsTableViewCell
        cell.fuelStation = self.fuelStation
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationOffersTableViewCell", for: indexPath) as! StationOffersTableViewCell
        cell.bannerView.image = self.banners[indexPath.row]
        return cell
    }
}
