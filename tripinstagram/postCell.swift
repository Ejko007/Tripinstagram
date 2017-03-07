//
//  postCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog
import MapKit

class postCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var postUserView: UIView!
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    
    @IBOutlet weak var picImg: UIImageView!
    
    @IBOutlet weak var uuidLbl: UILabel!
    
    @IBOutlet weak var postDateView: UIView!
    @IBOutlet weak var fromDateStrLbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var toDateStrLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var nrPersonsIcon: UIButton!
    @IBOutlet weak var nrPersonsLbl: UILabel!
    @IBOutlet weak var levelIcon: UIButton!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var zoomin: UIButton!
    @IBOutlet weak var postFinAndDestView: UIView!
    @IBOutlet weak var spentsIcon: UIButton!
    @IBOutlet weak var totalSpentsLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var mapmarkerIcon: UIButton!
    @IBOutlet weak var totalDistanceLbl: UILabel!
    @IBOutlet weak var kmLbl: UILabel!
    @IBOutlet weak var countriesView: UIView!
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var postMapView: MKMapView!
    
    
    
    //let pictureWidth = width - 20
    let pictureWidth = UIScreen.main.bounds.width
    let pictureHeight = round(UIScreen.main.bounds.height / 3) + 50
    
    var coordinates = [CLLocationCoordinate2D]()
    var annotations = [MKPointAnnotation]()
    var MapViewLocationManager:CLLocationManager! = CLLocationManager()

    // default function
    override func awakeFromNib() {
        super.awakeFromNib()
        
        postMapView.showsUserLocation = true
        postMapView.delegate = self
        MapViewLocationManager.delegate = self
        MapViewLocationManager.startUpdatingLocation()
        postMapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        // enable second tap to zoom picture
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(zoomImg))
        zoomTap.numberOfTapsRequired = 2
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
        
        // allow constraints
        postUserView.translatesAutoresizingMaskIntoConstraints = false
        postDateView.translatesAutoresizingMaskIntoConstraints = false
        postFinAndDestView.translatesAutoresizingMaskIntoConstraints = false
        avaImg.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        picImg.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        toDateStrLbl.translatesAutoresizingMaskIntoConstraints = false
        toDateLbl.translatesAutoresizingMaskIntoConstraints = false
        nrPersonsIcon.translatesAutoresizingMaskIntoConstraints = false
        nrPersonsLbl.translatesAutoresizingMaskIntoConstraints = false
        levelIcon.translatesAutoresizingMaskIntoConstraints = false
        levelLbl.translatesAutoresizingMaskIntoConstraints = false
        spentsIcon.translatesAutoresizingMaskIntoConstraints = false
        totalSpentsLbl.translatesAutoresizingMaskIntoConstraints = false
        currencyLbl.translatesAutoresizingMaskIntoConstraints = false
        mapmarkerIcon.translatesAutoresizingMaskIntoConstraints = false
        fromDateStrLbl.translatesAutoresizingMaskIntoConstraints = false
        fromDateLbl.translatesAutoresizingMaskIntoConstraints = false
        totalDistanceLbl.translatesAutoresizingMaskIntoConstraints = false
        kmLbl.translatesAutoresizingMaskIntoConstraints = false
        countriesView.translatesAutoresizingMaskIntoConstraints = false
        zoomin.translatesAutoresizingMaskIntoConstraints = false
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        postMapView.translatesAutoresizingMaskIntoConstraints = false


        self.contentView.backgroundColor = UIColor(red: 155 / 255, green: 155 / 255, blue: 155 / 255, alpha: 3 / 100)
        self.contentView.layer.cornerRadius = 0
        self.contentView.clipsToBounds = true
        
        // set opacity for postFinAndDestView
        postFinAndDestView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        totalSpentsLbl.textColor = UIColor.white
        currencyLbl.textColor = UIColor.white
        totalDistanceLbl.textColor = UIColor.white
        kmLbl.textColor = UIColor.white
        
        // change color of buttons image
        let origImage = UIImage(named: "zoom_in")
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        zoomin.setImage(tintedImage, for: .normal)
        zoomin.tintColor = .white
        
        let origSpentImage = UIImage(named: "spent_money")
        let tintedSpentImage = origSpentImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        spentsIcon.setImage(tintedSpentImage, for: .normal)
        spentsIcon.tintColor = .white
       
        let origRouteImage = UIImage(named: "distance")
        let tintedRouteImage = origRouteImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        mapmarkerIcon.setImage(tintedRouteImage, for: .normal)
        mapmarkerIcon.tintColor = .white
        
        levelIcon.layer.cornerRadius = 5
        levelIcon.clipsToBounds = true
       
        // feeduserview view opacity properties settings
        postUserView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        nrPersonsLbl.textColor = UIColor.black
        levelLbl.textColor = UIColor.black
        
        // hide uuid label
        uuidLbl.isHidden = true
        
        // constraints
        // vertical constraints
        
        self.pictureView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-45-[countryview(20)]-(\(pictureHeight - 65))-|",
            options: [],
            metrics: nil, views: ["countryview":countriesView]))
       
        self.pictureView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-45-[zoom(20)]-(\(pictureHeight - 65))-|",
            options: [],
            metrics: nil, views: ["zoom":zoomin]))
        
        self.postUserView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[ava(30)]-5-|",
            options: [],
            metrics: nil, views: ["ava":avaImg]))
        
        self.postUserView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[username(30)]-5-|",
            options: [],
            metrics: nil, views: ["username":usernameBtn]))
        
        self.postUserView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[personicon(30)]-5-|",
            options: [],
            metrics: nil, views: ["personicon":nrPersonsIcon]))

        self.postUserView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[nrperson]-5-|",
            options: [],
            metrics: nil, views: ["nrperson":nrPersonsLbl]))
        
        self.postUserView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[levelicon(30)]-5-|",
            options: [],
            metrics: nil, views: ["levelicon":levelIcon]))

        self.postUserView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[level]-5-|",
            options: [],
            metrics: nil, views: ["level":levelLbl]))
        
        self.postFinAndDestView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[postspenticon(30)]-5-|",
            options: [],
            metrics: nil, views: ["postspenticon":spentsIcon]))
        
        self.postFinAndDestView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[totalspent]-5-|",
            options: [],
            metrics: nil, views: ["totalspent":totalSpentsLbl]))
        
        self.postFinAndDestView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[currencyLbl]-5-|",
            options: [],
            metrics: nil, views: ["currencyLbl":currencyLbl]))
        
        self.postFinAndDestView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[mapmarker(30)]-5-|",
            options: [],
            metrics: nil, views: ["mapmarker":mapmarkerIcon]))
        
        self.postFinAndDestView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[totalDistance]-5-|",
            options: [],
            metrics: nil, views: ["totalDistance":totalDistanceLbl]))
        
        self.postFinAndDestView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[km]-5-|",
            options: [],
            metrics: nil, views: ["km":kmLbl]))
        
        self.postDateView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[fromdatestrlbl]-5-|",
            options: [],
            metrics: nil, views: ["fromdatestrlbl":fromDateStrLbl]))

        self.postDateView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[fromdatelbl]-5-|",
            options: [],
            metrics: nil, views: ["fromdatelbl":fromDateLbl]))
        
        self.postDateView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[todatestrlbl]-5-|",
            options: [],
            metrics: nil, views: ["todatestrlbl":toDateStrLbl]))

        self.postDateView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[todatelbl]-5-|",
            options: [],
            metrics: nil, views: ["todatelbl":toDateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[usernameview]-(-40)-[pic(\(pictureHeight))]-(\(-pictureHeight))-[pictureview]-(-40)-[postfindestbarview]-0-[postdateview]-0-[mapview(\(UIScreen.main.bounds.height - pictureHeight - 40 - (44 + 49)))]-|",
            options: [],
            metrics: nil, views: ["usernameview":postUserView, "pic":picImg, "pictureview":pictureView, "postfindestbarview":postFinAndDestView, "postdateview":postDateView, "mapview":postMapView]))
 
        // horizontal alignement
        self.pictureView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[country(30)]-(\(pictureWidth - 70))-[zoom(20)]-10-|",
            options: [],
            metrics: nil, views: ["country":countriesView, "zoom":zoomin]))
        
        self.postUserView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[ava(30)]-10-[username]-[personicon(30)]-5-[personsnr(20)]-10-[levelicon(30)]-5-[level(20)]-10-|",
            options: [],
            metrics: nil, views: ["ava":avaImg, "username":usernameBtn, "personicon":nrPersonsIcon, "personsnr":nrPersonsLbl, "levelicon":levelIcon, "level":levelLbl]))
 
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[pictureview(\(pictureWidth))]-0-|",
            options: [],
            metrics: nil, views: ["pictureview":pictureView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[usernameview(\(pictureWidth))]-0-|",
            options: [],
            metrics: nil, views: ["usernameview":postUserView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[pic(\(pictureWidth))]-0-|",
            options: [],
            metrics: nil, views: ["pic":picImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[postfindistbarview(\(pictureWidth))]-0-|",
            options: [],
            metrics: nil, views: ["postfindistbarview":postFinAndDestView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[postdatedetailsview(\(pictureWidth))]-0-|",
            options: [],
            metrics: nil, views: ["postdatedetailsview":postDateView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[mapview(\(pictureWidth))]-0-|",
            options: [],
            metrics: nil, views: ["mapview":postMapView]))
        
        self.postFinAndDestView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[spenticon(30)]-10-[spenttotal(\((pictureWidth / 2) - 95))]-5-[currencylbl(30)]-20-[distanceicon(30)]-10-[totaldistance(\((pictureWidth / 2) - 95))]-5-[kmlbl(30)]-10-|",
            options: [],
            metrics: nil, views: ["spenticon":spentsIcon, "spenttotal":totalSpentsLbl, "currencylbl":currencyLbl, "distanceicon":mapmarkerIcon, "totaldistance":totalDistanceLbl, "kmlbl":kmLbl]))
        
        self.postDateView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[fromdatestrlbl(20)]-10-[fromdatelbl(\((pictureWidth / 2) - 60))]-20-[todatestrlbl(20)]-10-[todatelbl(\((pictureWidth / 2) - 60))]-20-|",
            options: [],
            metrics: nil, views: ["fromdatestrlbl":fromDateStrLbl, "fromdatelbl":fromDateLbl,  "todatestrlbl":toDateStrLbl, "todatelbl":toDateLbl]))
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        avaImg.layer.borderColor = UIColor.white.cgColor
        avaImg.layer.borderWidth = 2
        
        // countries and zoom icons view settings
        countriesView.backgroundColor = UIColor(white: 1, alpha: 0)
        pictureView.backgroundColor = UIColor(white: 1, alpha: 0)
        
        self.contentView.bringSubview(toFront: pictureView)
        self.contentView.bringSubview(toFront: postUserView)
        self.contentView.bringSubview(toFront: postFinAndDestView)
        
        displayGeopoints()
     }
    
    // zooming in/out function
    func zoomImg () {
        
        // define frame of zoomed image
        let zoomed = CGRect(x: 0, y: self.contentView.center.y - self.contentView.center.x, width: self.contentView.frame.size.width, height: self.contentView.frame.size.width)

        // frame of unzoomed (small) image
        //let unzoomed = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
        let unzoomed = CGRect(x: 0, y: 0, width: pictureWidth, height: pictureHeight)
        
        // id picture is unzoomed, zoom it
        if picImg.frame == unzoomed {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.picImg.frame = zoomed
                
                // hide objects from background
                self.contentView.layer.cornerRadius = 0
                self.contentView.clipsToBounds = true
                self.contentView.backgroundColor = .black
                self.avaImg.alpha = 0
                self.usernameBtn.alpha = 0
                self.toDateLbl.alpha = 0
                self.levelLbl.alpha = 0
                self.uuidLbl.alpha = 0
                self.fromDateLbl.alpha = 0
                self.toDateLbl.alpha = 0
                self.nrPersonsIcon.alpha = 0
                self.nrPersonsLbl.alpha = 0
                self.levelIcon.alpha = 0
                self.levelLbl.alpha = 0
                self.spentsIcon.alpha = 0
                self.totalSpentsLbl.alpha = 0
                self.currencyLbl.alpha = 0
                self.mapmarkerIcon.alpha = 0
                self.totalDistanceLbl.alpha = 0
                self.kmLbl.alpha = 0
                self.countriesView.alpha = 0
                self.postFinAndDestView.alpha = 0
                self.postMapView.alpha = 0
                self.postUserView.alpha = 0
                self.postDateView.alpha = 0
                // self.pictureView.alpha = 0
            })
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.picImg.frame = unzoomed
                
                // unhide objects from background
                self.contentView.backgroundColor = .white
                self.avaImg.alpha = 1
                self.usernameBtn.alpha = 1
                self.uuidLbl.alpha = 1
                self.fromDateLbl.alpha = 1
                self.toDateLbl.alpha = 1
                self.nrPersonsIcon.alpha = 1
                self.nrPersonsLbl.alpha = 1
                self.levelIcon.alpha = 1
                self.levelLbl.alpha = 1
                self.spentsIcon.alpha = 1
                self.totalSpentsLbl.alpha = 1
                self.currencyLbl.alpha = 1
                self.mapmarkerIcon.alpha = 1
                self.totalDistanceLbl.alpha = 1
                self.kmLbl.alpha = 1
                self.countriesView.alpha = 1
                self.postFinAndDestView.alpha = 1
                self.postMapView.alpha = 1
                self.postUserView.alpha = 1
                self.postDateView.alpha = 1
                // self.pictureView.alpha = 1
                
                // add customized graphics to cell
                self.contentView.backgroundColor = UIColor(red: 155 / 255, green: 155 / 255, blue: 155 / 255, alpha: 3 / 100)
                self.contentView.layer.cornerRadius = 0
                self.contentView.clipsToBounds = true
                
            })
        }
    }
    
    @IBAction func zoomBtnClicked(_ sender: Any) {
        
       zoomImg()
        
    }
    
    // --------------------- mapview procedures -------------------------------------
    
    // display geopoint from the server
    func displayGeopoints () {
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
                    self.postMapView.addAnnotation(annotation)
                }
                
                _ = geoplacemarkArray.sorted(by: { (pg1: poigeoplacemark, pg2: poigeoplacemark) -> Bool in
                    return pg1.order < pg2.order
                })
                
                self.coordinates.removeAll(keepingCapacity: false)
                self.postMapView.removeOverlays(self.postMapView.overlays)
                for myannotation in self.annotations {
                    self.coordinates.append(myannotation.coordinate)
                }
                
                let polyline = MKPolyline(coordinates: &self.coordinates, count: self.coordinates.count)
                let visibleMapRect = self.postMapView.mapRectThatFits(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50))
                self.postMapView.setRegion(MKCoordinateRegionForMapRect(visibleMapRect), animated: true)
                
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
            self.postMapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
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

    func mapView (_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        switch (newState) {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
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
            
            let colorPointAnnotation = annotation as! ColorPointAnnotation
            annotationView?.pinTintColor = colorPointAnnotation.pinColor
            
            annotationView?.canShowCallout = true
            annotationView?.isEnabled = true
            annotationView?.isDraggable = false
        } else {
            annotationView?.annotation = annotation
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
    
    @IBAction func levelIconBtn_tapped(_ sender: Any) {
        
        
    }
    
    @IBAction func nrPersonsIconBtn_tapped(_ sender: Any) {
        
        
        
    }
    
    @IBAction func spentsIconBtn_tapped(_ sender: Any) {
        
        
    }
    
    @IBAction func mapmarkerIconBtn_tapped(_ sender: Any) {
        
        
    }
    
    
}
