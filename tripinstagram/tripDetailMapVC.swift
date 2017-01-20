//
//  tripDetailMapVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit
import MapKit
import Parse

class ColorPointAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    var pinuuid: String
    
    init(pinColor:UIColor, pinuuid:String) {
        self.pinColor = pinColor
        self.pinuuid = pinuuid
        super.init()
    }
}

class tripDetailMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeControl: UISegmentedControl!
    
    var MapViewLocationManager:CLLocationManager! = CLLocationManager()
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    var tappedCoordinate = CLLocationCoordinate2D()
    var annotations = [MKPointAnnotation]()
    var coordinates = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        MapViewLocationManager.delegate = self
        MapViewLocationManager.startUpdatingLocation()
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        // navigation bar
        self.navigationItem.title = trip_list_str.uppercased()
        
        // Create left navigation item - back button
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backBtn
        backBtn.tintColor = .white
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height

        // allow constraints
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapTypeControl.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[mapview(\(width))]-|",
            options: [],
            metrics: nil, views: ["mapview":mapView]))

        let h = self.tabBarController?.tabBar.frame.height
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[mapview(\(height - (h! + 60)))]-|",
            options: [],
            metrics: nil, views: ["mapview":mapView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-50-[maptype(\(width - 100))]-50-|",
            options: [],
            metrics: nil, views: ["maptype":mapTypeControl]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[maptype(\(25))]-20-|",
            options: [],
            metrics: nil, views: ["maptype":mapTypeControl]))
       
        // customize segmented controller for map type
        mapTypeControl.tintColor = .white
        mapTypeControl.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
        mapTypeControl.setTitle(standard_str, forSegmentAt: 0)
        mapTypeControl.setTitle(satelite_str, forSegmentAt: 1)
        mapTypeControl.setTitle(hybrid_str, forSegmentAt: 2)
        mapTypeControl.layer.cornerRadius = 5.0
        mapTypeControl.clipsToBounds = true
        // initial setting of map type controller
        mapTypeControl.selectedSegmentIndex = 0
        
        self.mapView.addSubview(mapTypeControl)
        
        if #available(iOS 9.0, *) {
            mapView.showsCompass = true
            mapView.showsScale = true
            mapView.showsTraffic = true
        }
        
        let longpressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pinLocation))
        longpressGestureRecognizer.minimumPressDuration = 0.3
        mapView.addGestureRecognizer(longpressGestureRecognizer)

        
    }
    
    // pin procedure to pin location on map
    func pinLocation(sender: UILongPressGestureRecognizer) {
        
        if sender.state != .ended {
            return
        }
        
        // Get location of touch
        let tappedPoint = sender.location(in: mapView)
        
        // Convert point to coordinates
        let coordinate = mapView.convert(tappedPoint, toCoordinateFrom: mapView)
        tappedCoordinate = coordinate
        
        // Annotate on the map view
        // let annotation = MKPointAnnotation()
        let annotation = ColorPointAnnotation(pinColor: .green, pinuuid: "")
        annotation.pinColor = .green
        annotation.coordinate = coordinate
        
        let point = tappedCoordinate
        annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
        let title = trip_point
        annotation.title = title
        let subtitle = not_specified_str
        annotation.subtitle = subtitle
        
        mapView.addAnnotation(annotation)

        // Store annotation for later use
        annotations.append(annotation)
        
        mapView.showAnnotations([annotation], animated: true)
    }

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let annotationView = views[0]
        let endFrame = annotationView.frame
        annotationView.frame = endFrame.offsetBy(dx: 0, dy: -600)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            annotationView.frame = endFrame
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let detailButton: UIButton = UIButton(type: UIButtonType.detailDisclosure)
        detailButton.addTarget(self, action: #selector(showAnnotationDisclosure(sender:)), for: .touchUpInside)
        
        
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            let colorPointAnnotation = annotation as! ColorPointAnnotation
            annotationView?.pinTintColor = colorPointAnnotation.pinColor
            
            annotationView?.canShowCallout = true
            annotationView?.isEnabled = true
            annotationView?.isDraggable = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        leftIconView.image = UIImage(named: "chooser-moment-icon-place.png")
        annotationView?.leftCalloutAccessoryView = leftIconView
        annotationView?.rightCalloutAccessoryView = detailButton
        
        // Pin color customization
        if #available(iOS 9.0, *) {
            // annotationView?.pinTintColor = colorPointAnnotation.pinColor
        }
        return annotationView
    }
    
    // info icon button annotatio clicked
    func showAnnotationDisclosure(sender: AnyObject) {
        print("Disclosure button clicked")
    }

    func mapView (_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        switch (newState) {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "tripDetailMapPOI4MapVC") as! tripDetailMapPOI4MapVC
        
        destination.isNewPOI = false
        
        poiuuid.removeAll(keepingCapacity: false)
        let poiannotation = view.annotation as! ColorPointAnnotation
        poiuuid.append(poiannotation.pinuuid)

        self.navigationController?.pushViewController(destination, animated: true)
        
        print("annotation tapped....")
    }

    // go back function
    func back(sender: UIBarButtonItem) {
        //push back
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func maptypeControlAction(_ sender: UISegmentedControl) {
        
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            mapView.mapType = .standard
        }
        
        
    }
    
    // display geopoint from the server
    override func viewDidAppear(_ animated: Bool) {
        var annotationColor = UIColor()
        
        let annotationQuery = PFQuery(className: "tripsegmentpoi")
        annotationQuery.whereKey("uuid", equalTo: postuuid.last!)
        annotationQuery.findObjectsInBackground(block: { (locations: [PFObject]?, locationsError: Error?) in
            if locationsError == nil {
                print("Successful query for annotations")
                
                let myLocations = locations! as [PFObject]
                
                // clean up
                self.annotations.removeAll(keepingCapacity: false)
                
                for location in myLocations {
                    let point = location["location"] as! PFGeoPoint
                    // let annotation = MKPointAnnotation()
                    let poitype = location["poitype"] as! Int
                    if poitype == 0 {
                       annotationColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
                    } else {
                        annotationColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
                    }
                    let poiuuid = location["poiuuid"] as! String
                    let annotation = ColorPointAnnotation(pinColor: annotationColor, pinuuid: poiuuid)
                    annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                    let title = location["poiname"] as! String
                    annotation.title = title
                    let subtitle = location["poidescription"] as! String
                    annotation.subtitle = subtitle
                    //let description = location["poidetails"] as! String
                    //annotation.description = mydescription
                    
                    self.annotations.append(annotation)
                    self.mapView.addAnnotation(annotation)
                }
                
                self.mapView.removeOverlays(self.mapView.overlays)
                for myannotation in self.annotations {
                    self.coordinates.append(myannotation.coordinate)
                }
                
                let polyline = MKPolyline(coordinates: &self.coordinates, count: self.coordinates.count)
                let visibleMapRect = self.mapView.mapRectThatFits(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
                self.mapView.setRegion(MKCoordinateRegionForMapRect(visibleMapRect), animated: true)
                
                var index = 0
                while index < self.annotations.count - 1 {
                    self.drawDirection(self.annotations[index].coordinate, endPoint: self.annotations[index + 1].coordinate)
                    index += 1
                }
                
            } else {
                print(locationsError!.localizedDescription)
            }
        })
    }
    
    // drawing route in details
    func drawDirection(_ startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D) {
        
        // Create map items from coordinate
        let startPlacemark = MKPlacemark(coordinate: startPoint, addressDictionary: nil)
        let endPlacemark = MKPlacemark(coordinate: endPoint, addressDictionary: nil)
        let startMapItem = MKMapItem(placemark: startPlacemark)
        let endMapItem = MKMapItem(placemark: endPlacemark)
        
        // Set the source and destination of the route
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = startMapItem
        directionRequest.destination = endMapItem
        directionRequest.transportType = MKDirectionsTransportType.automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (routeResponse, routeError) -> Void in
            
            guard let routeResponse = routeResponse else {
                if let routeError = routeError {
                    print("Error: \(routeError)")
                }
                
                return
            }
            
            let route = routeResponse.routes[0]
            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
    }


}
