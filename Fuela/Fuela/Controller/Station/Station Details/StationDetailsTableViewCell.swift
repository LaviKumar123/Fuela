//
//  StationDetailsTableViewCell.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit

class StationDetailsTableViewCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var fuelStation: FuelStation! {
        didSet {
            self.nameLabel.text = fuelStation.name
            self.addressLabel.text = fuelStation.vicinity
        }
    }
    
    
    //MARK:- Button Action
    @IBAction func directionButtonTapped(_ sender: UIButton) {
        self.openGoogleMap()
    }
    
    func openGoogleMap() {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(self.fuelStation.latitude),\(self.fuelStation.longitude)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(self.fuelStation.latitude),\(self.fuelStation.longitude)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
        
    }
}
