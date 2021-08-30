//
//  StationViewController.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StationViewController: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var stationTableView: UITableView!
    
    let locationManager = CLLocationManager()
    var fuelStations = [FuelStation]()
    var stretchyHeaderView : StationMapView!
    
    //MARK:- Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.headerViewSetup()
//        self.getFuelStation()
        self.locationManagerSetup()
    }
    
    func headerViewSetup() {
        let nibViews = Bundle.main.loadNibNamed("StationMapView", owner: self, options: nil)
        self.stretchyHeaderView = nibViews!.first as? StationMapView
        self.stationTableView.addSubview(stretchyHeaderView)
    }
    
    func locationManagerSetup() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    //MARK:- Button Action
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
}

extension StationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.getPetrolStation(locValue.latitude, longitude: locValue.longitude)
        manager.stopUpdatingLocation()
    }
}

//MARK:- Table View Dlegate And Data Source
extension StationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fuelStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationTableViewCell", for: indexPath) as! StationTableViewCell
        cell.fuelStation = self.fuelStations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = HOME_STORYBOARD.instantiateViewController(withIdentifier: "StationDetailsViewController") as! StationDetailsViewController
        vc.fuelStation = self.fuelStations[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension StationViewController {
    func getPetrolStation(_ latitude: Double, longitude: Double) {
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=15000&type=gas_station&key=\(MAP_API_KEY)"
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestWithoutBaseURL(url, method: .post, header: [:], params: [:]) { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["status"] as! String == "OK" {
                    if let stations = (response as! [String:Any])["results"] as? [[String:Any]] {
                        self.fuelStations = stations.map({FuelStation($0)})
                        self.stretchyHeaderView.mapViewSetup(self.fuelStations)
                        self.stationTableView.reloadData()
                    }
                }else {
                    let message = (response as! [String:Any])["msg"] as? String ?? ""
                    AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
    
    func getFuelStation() {
        let param = [
            "user_id"    : AppUser.shared.id!,
        ]
        
        print(param)
        
        Indicator.shared.startAnimating(self.view)
        
        WebAPI.requestToPostBodyWithHeader(URLConstant.getfuelstation, param as [String : AnyObject], header: [:])  { (response, isSuccess) in
            
            Indicator.shared.stopAnimating()
            
            print(response)
            
            if isSuccess {
                
                if (response as! [String:Any])["result"] as! Int == 1 {
                    if let stations = (response as! [String:Any])["data"] as? [[String:Any]] {
                        self.fuelStations = stations.map({FuelStation($0)})
                        self.stretchyHeaderView.mapViewSetup(self.fuelStations)
                        self.stationTableView.reloadData()
                    }
                }else {
                    if let message = (response as! [String:Any])["Error"] as? String {
                        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
                    }else if let error = (response as! [String:Any])["errors"] as? [String:Any],
                             let userIDError = error["user_id"] as? String{
                        AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: userIDError)
                    }
                    
                }
            }else {
                let message = (response as! [String:Any])["Error"] as? String ?? ""
                AlertView.show(self, image: #imageLiteral(resourceName: "Alert for deny quotation"), message: message)
            }
        }
    }
}
