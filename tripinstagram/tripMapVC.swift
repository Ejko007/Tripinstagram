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

class tripMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var MapViewLocationManager:CLLocationManager! = CLLocationManager()
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.showsUserLocation = true
        mapView.delegate = self
        MapViewLocationManager.delegate = self
        MapViewLocationManager.startUpdatingLocation()
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height

        // allow constraints
        mapView.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        let topConstraint = NSLayoutConstraint(item: mapView,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: self.topLayoutGuide,
                                               attribute: .bottom,
                                               multiplier: 1,
                                               constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: self.view,
                                                    attribute: .trailingMargin,
                                                    relatedBy: .equal,
                                                    toItem: mapView,
                                                    attribute: .trailing,
                                                    multiplier: 1,
                                                    constant: 0)
        
        let bottomConstraint = NSLayoutConstraint(item: self.bottomLayoutGuide,
                                                  attribute: .top,
                                                  relatedBy: .equal,
                                                  toItem: mapView,
                                                  attribute: .bottom,
                                                  multiplier: 1,
                                                  constant: 0)
        
        let widthConstraint = NSLayoutConstraint(item: mapView,
                                                 attribute: .width,
                                                 relatedBy: .equal,
                                                 toItem: nil,
                                                 attribute: .notAnAttribute,
                                                 multiplier: 1,
                                                 constant: width)
        
        self.view.addConstraints([trailingConstraint])
        view.addConstraints([topConstraint, bottomConstraint, widthConstraint])

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[mapview(\(height))]-|",
            options: [],
            metrics: nil, views: ["mapview":mapView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[mapview(\(width))]-|",
            options: [],
            metrics: nil, views: ["mapview":mapView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-20-[cancel(35)]",
            options: [],
            metrics: nil, views: ["cancel":cancelBtn]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[cancel(35)]-10-|",
            options: [],
            metrics: nil, views: ["cancel":cancelBtn]))
           
        mapView.delegate = self
        if #available(iOS 9.0, *) {
            mapView.showsCompass = true
            mapView.showsScale = true
            mapView.showsTraffic = true
        }
    }

    // display geopoint from the server
    override func viewDidAppear(_ animated: Bool) {
        var coordinates = [CLLocationCoordinate2D]()
        var annotations = [MKPointAnnotation]()

        let annotationQuery = PFQuery(className: "triproute")
        annotationQuery.whereKey("uuid", equalTo: postuuid.last!)
        annotationQuery.findObjectsInBackground(block: { (locations: [PFObject]?, locationsError: Error?) in
            if locationsError == nil {
                print("Successful query for annotations")

                let myLocations = locations! as [PFObject]
                
                for location in myLocations {
                    let point = location["location"] as! PFGeoPoint
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
                    let title = location["title"] as! String
                    annotation.title = title
                    let subtitle = location["subtitle"] as! String
                    annotation.subtitle = subtitle
                    //let description = location["description"] as! String
                    //annotation.description = ""
                    annotations.append(annotation)
                    self.mapView.addAnnotation(annotation)
                }
                
                self.mapView.removeOverlays(self.mapView.overlays)
                for myannotation in annotations {
                    coordinates.append(myannotation.coordinate)
                }
                
                let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
                let visibleMapRect = self.mapView.mapRectThatFits(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
                self.mapView.setRegion(MKCoordinateRegionForMapRect(visibleMapRect), animated: true)
                
                var index = 0
                while index < annotations.count - 1 {
                    self.drawDirection(startPoint: annotations[index].coordinate, endPoint: annotations[index + 1].coordinate)
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
            annotationView?.pinTintColor = UIColor.red
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
    func drawDirection(startPoint: CLLocationCoordinate2D, endPoint: CLLocationCoordinate2D) {
        
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
    
    @IBAction func cancelBtn_clicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
//        dismiss(animated: true, completion: nil)
//    }

}
