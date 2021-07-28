//
//  DetailMapCell.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/19.
//

import UIKit
import MapKit
import GoogleMaps

class DetailMapCell: UITableViewCell {
    
    @IBOutlet var mapView: MKMapView!
//    @IBOutlet var googleMapView: GMSMapView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(location: String) {
        
        let geoCoder = CLGeocoder()  //取得位置
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let placemarks = placemarks {
                let placemark = placemarks[0] //取得地點標記
                
                let annotation = MKPointAnnotation()  //加入標記
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                }
                //設定縮放
                let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                self.mapView.setRegion(region, animated: false)
                

            }
        }
    }
    
}
