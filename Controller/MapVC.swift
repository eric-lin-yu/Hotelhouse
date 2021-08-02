//
//  MapVC.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/19.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var mapdatail : Info!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        showMapView()
    }
    
    func showMapView() {
        //地址轉換為座標後並標記在地圖上
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(mapdatail.add) { (placemarks, error) in
            if let error = error {
                print("地址取得失敗\(error)")
                return
            }
            if let placemarks = placemarks {
                let placemark = placemarks[0] //取得第一個位置
                let annotation = MKPointAnnotation() //加上標記
                annotation.title = self.mapdatail.name
                annotation.subtitle = self.mapdatail.town
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    //客製化標記視團
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        let showText = ["🙇🏻","🙋🏻‍♀️","🗿","🤗","⛩"]
        let random = Int.random(in: 0..<showText.count)
        annotationView?.glyphText = showText[random]
        
        annotationView?.markerTintColor = UIColor.orange

        return annotationView
    }
    @IBAction func goMapNavigation(_ sender: Any) {
        let aler = UIAlertController(title: NSLocalizedString("Notice!", comment: ""), message: NSLocalizedString("appleMap", comment: ""), preferredStyle: .alert)
        let ok = UIAlertAction(title: "Let's GO!", style: .default) { (gomapNavigation) in

            let geocoder = CLGeocoder()
            let adderss = self.mapdatail.add
            geocoder.geocodeAddressString(adderss) { (placemarks, error) in
                if let error = error{
                    print("導航失敗\(error)")
                }
                guard let placemarks = placemarks, placemarks.count > 0 else {
                    return
                }
                let theFirstPlaceMark = placemarks[0]
                let taragetPlace = MKPlacemark(placemark: theFirstPlaceMark)
                let targetMapItem = MKMapItem(placemark: taragetPlace)
                let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                targetMapItem.openInMaps(launchOptions: options)
            }
        }
        let canel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default, handler: nil)
        aler.addAction(ok)
        aler.addAction(canel)
        self.present(aler, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
