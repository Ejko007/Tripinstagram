//
//  ViewConmapDetailHandleMapSearchVC.swift
//  MapKitTutorial
//
//  Created by Robert Chen on 12/23/15.
//  Copyright © 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import MapKit
import Parse
import PopupDialog

protocol HandleMapSearch {
    func dropPinZoomIn(_ placemark:MKPlacemark)
    func setSearchBarText(_ text: String)
}

class tripDetailHandleMapSearchVC : UIViewController {
    
    var selectedPin:MKPlacemark? = nil
    
    var resultSearchController:UISearchController? = nil
    
    let locationManager = CLLocationManager()
    
    var POIAnnotation = MKPointAnnotation()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar title
        self.navigationItem.title = trip_POI_search_str.uppercased()

        // add mapview contraints
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[mapview]-0-|",
            options: [],
            metrics: nil, views: ["mapview":mapView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            // withVisualFormat: "V:|-0-[mapview(\(height - (h! + 60)))]-|",
            withVisualFormat: "V:|-0-[mapview]-0-|",
            options: [],
            metrics: nil, views: ["mapview":mapView]))
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "tripDetailMapLocationSearchTable") as! tripDetailMapLocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}

extension tripDetailHandleMapSearchVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

extension tripDetailHandleMapSearchVC: HandleMapSearch {
    func dropPinZoomIn(_ placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
        }
        // add annotation to global variable
        POIAnnotation = annotation
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func setSearchBarText(_ text: String) {
        resultSearchController?.searchBar.text = text
    }
    
    func showAnnotationDisclosure(sender: AnyObject) {
        // print("Disclosure button clicked")
        
        // send related data to global variables
        descriptionuuid = "Hello"

        let destination = self.storyboard?.instantiateViewController(withIdentifier: "tripDetailMapPOIDescVC") as! tripDetailMapPOIDescVC
        self.navigationController?.pushViewController(destination, animated: true)
    }

    
    func savePOI() {
        
        var order:Int = 0
        
        let annotationQuery = PFQuery(className: "tripsegmentpoi")
        annotationQuery.whereKey("uuid", equalTo: postuuid.last!)
        annotationQuery.countObjectsInBackground (block: { (count: Int32, error: Error?) in
            if error == nil {
                order = Int(count)
                // save POI coorditates to server
                let poiObj = PFObject(className: "tripsegmentpoi")
                // let mypoint = mapView.annotations.last
                let mypoint = self.POIAnnotation
                
                poiObj["poiname"] = mypoint.title!
                poiObj["poidescription"] = mypoint.subtitle!
                poiObj["poitype"] = 0
                poiObj["poiorder"] = order
                // poiObj["poidetails"] = (mypoint?.description)! as String
                poiObj["poidetails"] = descriptionuuid
                let point = PFGeoPoint(latitude: (mypoint.coordinate.latitude), longitude: (mypoint.coordinate.longitude))
                poiObj["location"] = point
                poiObj["uuid"] = postuuid.last!
                let uuid = UUID().uuidString
                poiObj["poiuuid"] = "\(PFUser.current()?.username) \(uuid)"
                
                poiObj.saveInBackground(block: { (success:Bool, error:Error?) in
                    if error == nil {
                        if success {
                            let okbtn = DefaultButton(title: ok_str, action: nil)
                            let complMenu = PopupDialog(title: annotation_str, message: annotation_save_confirm_str)
                            complMenu.addButtons([okbtn])
                            self.present(complMenu, animated: true, completion: nil)
                            
                            // remove poi pin from the map
                            self.mapView.removeAnnotation(mypoint)
                            
                            // switch to poi list view controller
                            self.tabBarController!.selectedIndex = 1
                            
                            // refreshing function
                            // send notification if we liked to refresh TableView
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "save"), object: nil)
                            
                        } else {
                            print(error!.localizedDescription)
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            }
        })
    }
}

extension tripDetailHandleMapSearchVC : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.red
        pinView?.canShowCallout = true
        
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "accept"), for: UIControlState())
        button.backgroundColor = .clear
        // button.addTarget(self, action: #selector(tripDetailHandleMapSearchVC.getDirections), for: .touchUpInside)
        button.addTarget(self, action: #selector(savePOI), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        let detailButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        detailButton.setBackgroundImage(UIImage(named: "comments"), for: UIControlState())
        detailButton.backgroundColor = .clear
        detailButton.addTarget(self, action: #selector(showAnnotationDisclosure(sender:)), for: .touchUpInside)
        pinView?.rightCalloutAccessoryView = detailButton
        return pinView
    }
}
