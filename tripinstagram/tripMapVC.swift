//
//  tripMapVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import MapKit
import Parse

struct poigeoplacemark {
    var order = Int()
    var locationName = String()
    var streetName = String()
    var cityName = String()
    var zipName = String()
    var countryName = String()
}

var itineraryInstructions = [String]()
var itineraryInstructionsArray = [itineraryInstructions]
var itineraryDistances = [Double]()
var geoplacemarkArray = [poigeoplacemark]()

class tripMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapTypeControl: UISegmentedControl!
    
    var MapViewLocationManager:CLLocationManager! = CLLocationManager()
 
    var coordinates = [CLLocationCoordinate2D]()
    var annotations = [MKPointAnnotation]()
    
    // delegating user name from other views
    var username = String()
    var uuid = String()
    
    var startLocation:CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance:Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

        mapView.showsUserLocation = true
        mapView.delegate = self
        MapViewLocationManager.delegate = self
        MapViewLocationManager.startUpdatingLocation()
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        // new edit button
        let editBtn = UIBarButtonItem(image: UIImage(named: "edit.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(edit))

        // show edit button for current user post only
        if PFUser.current()?.username == self.username.lowercased() {
            self.navigationItem.rightBarButtonItems = [editBtn]
            editBtn.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItems = []
            editBtn.isEnabled = false
        }
        
        // allow constraints
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapTypeControl.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[mapview]-0-|",
            options: [],
            metrics: nil, views: ["mapview":mapView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[mapview]-0-|",
            options: [],
            metrics: nil, views: ["mapview":mapView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-50-[maptype]-50-|",
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
        let tappedCoordinate = mapView.convert(tappedPoint, toCoordinateFrom: mapView)
        
        // Annotate on the map view
        let annotation = MKPointAnnotation()
        annotation.coordinate = tappedCoordinate
        
        // Store annotation for later use
        annotations.append(annotation)
        
        mapView.showAnnotations([annotation], animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let annotationView = views[0]
        let endFrame = annotationView.frame
        annotationView.isDraggable = true
        annotationView.frame = endFrame.offsetBy(dx: 0, dy: -600)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            annotationView.frame = endFrame
        })
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
        var mygeoplacemark = poigeoplacemark()
        
        let annotationQuery = PFQuery(className: "tripsegmentpoi")
        annotationQuery.whereKey("uuid", equalTo: postuuid.last!)
        annotationQuery.order(byAscending: "poiorder")
        annotationQuery.findObjectsInBackground(block: { (locations: [PFObject]?, locationsError: Error?) in
            if locationsError == nil {
                print("Successful query for annotations")

                let myUnsortedLocations = locations! as [PFObject]
                let myLocations = myUnsortedLocations.sorted(by: { (s1: PFObject, s2: PFObject) -> Bool in
                    return (s1["poiorder"] as! Int) < (s2["poiorder"] as! Int)
                })
//                
//                print("\(myLocations[0]["poiorder"] as! Int)")
//                print("\(myLocations[0]["poiname"] as! String)")
//                print("\(myLocations[1]["poiorder"] as! Int)")
//                print("\(myLocations[1]["poiname"] as! String)")
                
                geoplacemarkArray.removeAll(keepingCapacity: false)
                
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

                    // get address from location
                    let geoCoder = CLGeocoder()
                    let place = CLLocation(latitude: point.latitude, longitude: point.longitude)
                    
                    geoCoder.reverseGeocodeLocation(place, completionHandler: { (placemarks, error) in
                        
                        var placeMark: CLPlacemark!
                        placeMark = placemarks?[0]
                        
                        // address dictionary
                        if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                            print(locationName)
                            mygeoplacemark.locationName = locationName as String
                        }

                        // stret address
                        if let streetName = placeMark.addressDictionary!["Throughfare"] as? NSString {
                            print(streetName)
                            mygeoplacemark.streetName = streetName as String
                        }

                        // city name
                        if let cityName = placeMark.addressDictionary!["City"] as? NSString {
                            print(cityName)
                            mygeoplacemark.cityName = cityName as String
                        }
                        
                        // zip name
                        if let zipName = placeMark.addressDictionary!["ZIP"] as? NSString {
                            print(zipName)
                            mygeoplacemark.zipName = zipName as String
                        }
                        
                        // country name
                        if let countryName = placeMark.addressDictionary!["Country"] as? NSString {
                            print(countryName)
                            mygeoplacemark.countryName = countryName as String
                        }
                        
                        // poiorder
                        if let poiorder = location["poiorder"] as? Int {
                            print(poiorder)
                            mygeoplacemark.order = poiorder as Int
                        }
                        
                        geoplacemarkArray.append(mygeoplacemark)
                    })
                    
                    self.annotations.append(annotation)
                    self.mapView.addAnnotation(annotation)
                }
                
                _ = geoplacemarkArray.sorted(by: { (pg1: poigeoplacemark, pg2: poigeoplacemark) -> Bool in
                    return pg1.order < pg2.order
                })

                self.coordinates.removeAll(keepingCapacity: false)
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
    
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        let detailButton: UIButton = UIButton(type: UIButtonType.detailDisclosure)
        detailButton.addTarget(self, action: #selector(showAnnotationDisclosure(sender:)), for: .touchUpInside)

        
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        annotationView?.isDraggable = true
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.isEnabled = true
        }
        
        let leftIconView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
        leftIconView.image = UIImage(named: "chooser-moment-icon-place.png")
        annotationView?.leftCalloutAccessoryView = leftIconView
        annotationView?.rightCalloutAccessoryView = detailButton
        
        // Pin color customization
        if #available(iOS 9.0, *) {
            // annotationView?.pinTintColor = UIColor.red
        }
        
        return annotationView
    }
    
    // info icon button annotatio clicked
    func showAnnotationDisclosure(sender: AnyObject) {
        print("Disclosure button clicked")
    }
    
    // rendering route between annotations
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.lineWidth = 3.0
        renderer.strokeColor = UIColor.blue
        renderer.alpha = 0.5
        
        let visibleMapRect = mapView.mapRectThatFits(renderer.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
        mapView.setRegion(MKCoordinateRegionForMapRect(visibleMapRect), animated: true)
        
        return renderer
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
        
        itineraryDistances.removeAll(keepingCapacity: false)
        itineraryInstructionsArray.removeAll(keepingCapacity: false)
        
        // calculate distance and prepare itinerary
        directions.calculate { (routeResponse, routeError) -> Void in
            
            guard let routeResponse = routeResponse else {
                if let routeError = routeError {
                    print("Error: \(routeError)")
                }
                
                return
            }
            
            for route in routeResponse.routes {
                print("Distance = \(route.distance)")
                itineraryDistances.append((route.distance / 1000.00).roundTo(places: 2))  // in kilometers
                itineraryInstructions.removeAll(keepingCapacity: false)
                for step in route.steps {
                    print(step.instructions)
                    itineraryInstructions.append(step.instructions)
                }
                itineraryInstructionsArray.append(itineraryInstructions)
            }
            
            let route = routeResponse.routes[0]
            self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //
    //        if startLocation == nil {
    //            startLocation = locations.first
    //        } else {
    //            if let lastLocation = locations.last {
    //                let distance = startLocation.distance(from: lastLocation)
    //                let lastDistance = lastLocation.distance(from: lastLocation)
    //                traveledDistance += lastDistance
    //                print( "\(startLocation)")
    //                print( "\(lastLocation)")
    //                print("FULL DISTANCE: \(traveledDistance)")
    //                print("STRAIGHT DISTANCE: \(distance)")
    //            }
    //        }
    //        lastLocation = locations.last
    //    }

    // edit map coordinates - opening other tabbar controller
    func edit() {
        var nextTVC = UITabBarController()
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

        nextTVC = storyBoard.instantiateViewController(withIdentifier: "tabbartripDetailMap") as! tabbartripDetailMap
        
        // set initial tab bar to 0
        // tabbartripDetailMap
        nextTVC.selectedIndex = 0
        nextTVC.delegate = self
        self.present(nextTVC, animated: true, completion: nil)
    }
        
}
