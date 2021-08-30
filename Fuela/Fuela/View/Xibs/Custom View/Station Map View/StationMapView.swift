//
//  StationMapView.swift
//  Fuela
//
//  Created by lavi on 11/08/20.
//  Copyright © 2020 lavi. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GSKStretchyHeaderView

class StationMapView: GSKStretchyHeaderView {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    func mapViewSetup(_ fuelStations: [FuelStation]) {
        
        for fuelStation in fuelStations {
            let camera = GMSCameraPosition.camera(withLatitude: fuelStation.latitude, longitude: fuelStation.longitude, zoom: 12.0)
            self.mapView.camera = camera
            
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: fuelStation.latitude, longitude: fuelStation.longitude))
            marker.title = fuelStation.name
            marker.snippet = fuelStation.vicinity
            marker.map = self.mapView
        }
    }
}
