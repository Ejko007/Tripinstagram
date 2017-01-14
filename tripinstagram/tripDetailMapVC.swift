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


class tripDetailMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tripDetailMapNavBar: UINavigationBar!
    @IBOutlet weak var tripDetailMapNavItem: UINavigationItem!
    @IBOutlet weak var mapTypeControl: UISegmentedControl!
    
    var MapViewLocationManager:CLLocationManager! = CLLocationManager()
    var currentLoc: PFGeoPoint! = PFGeoPoint()
    
    var tappedCoordinate = CLLocationCoordinate2D()
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.showsUserLocation = true
        mapView.delegate = self
        MapViewLocationManager.delegate = self
        MapViewLocationManager.startUpdatingLocation()
        mapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        // navigation bar
        tripDetailMapNavBar.barTintColor = UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)
        tripDetailMapNavBar.isTranslucent = false
        tripDetailMapNavBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        tripDetailMapNavBar.backgroundColor = .white
        tripDetailMapNavBar.tintColor = .white
        tripDetailMapNavItem.title = trip_list_str.uppercased()
        
        // Create left navigation item - back button
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back))
        tripDetailMapNavItem.leftBarButtonItem = backBtn
        backBtn.tintColor = .white
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height

        // allow constraints
        mapView.translatesAutoresizingMaskIntoConstraints = false
        tripDetailMapNavBar.translatesAutoresizingMaskIntoConstraints = false
        mapTypeControl.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[mapview(\(width))]-|",
            options: [],
            metrics: nil, views: ["mapview":mapView]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[navbar(\(width))]-|",
            options: [],
            metrics: nil, views: ["navbar":tripDetailMapNavBar]))

        let h = self.tabBarController?.tabBar.frame.height
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[navbar(60)]-0-[mapview(\(height - (h! + 60)))]-|",
            options: [],
            metrics: nil, views: ["navbar":tripDetailMapNavBar,"mapview":mapView]))
        
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
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        let point = tappedCoordinate
        annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
        let title = "Hello"
        annotation.title = title
        let subtitle = "Dolly"
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
            annotationView?.canShowCallout = true
            annotationView?.isEnabled = true
            annotationView?.isDraggable = true
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
