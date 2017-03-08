//
//  tripDetailMapPOI4MapVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog

extension UIViewController {
    func performSegueToReturnBack() {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

class tripDetailMapPOI4MapVC: UIViewController, UINavigationBarDelegate, UITabBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var POINameLbl: UILabel!
    @IBOutlet weak var POINameTxt: UITextField!
    @IBOutlet weak var POIDescLbl: UILabel!
    @IBOutlet weak var POIDescTxt: UITextField!
    @IBOutlet weak var POICommentLbl: UILabel!
    @IBOutlet weak var POICommentTxtView: UITextView!
    @IBOutlet weak var POILatitudeLbl: UILabel!
    @IBOutlet weak var POILatitudeTxt: UITextField!
    @IBOutlet weak var POILongitudeLbl: UILabel!
    @IBOutlet weak var POILongitudeTxt: UITextField!
    @IBOutlet weak var POITypeBtn: DLRadioButton!
    @IBOutlet weak var POILatLongFrameView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var POIuuidLbl: UILabel!
    @IBOutlet weak var POIActualPositionBtn: UIButton!
    
    var pointtype : Int = 0
    var isNewPOI : Bool = true
    
    // size of screen
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var isOwner = true
    
    // keyboard to hold frame size
    var keyboard = CGRect()

    // location manager for actual geolocation
    let manager = CLLocationManager()
    var curLocationLatitude = Double()
    var curLocationLongitude = Double()

    override func viewDidLoad() {
        super.viewDidLoad()

        isAuthorizedtoGetUserLocation()
        
        // initialize location manager and delegate it
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.requestLocation()
            manager.startUpdatingLocation()
        } else {
            manager.requestAlwaysAuthorization()
        }

        // navigation bar title
        self.navigationItem.title = trip_point.uppercased()
        
        // hide uuid stored in uuid label
        POIuuidLbl.isHidden = true
        
        // Create left and right button for navigation item
        // new back button
        if !isNewPOI {
            let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back))
            self.navigationItem.leftBarButtonItem = backBtn
            backBtn.tintColor = .white
        }
        
        // add save button to the right
        let saveBtn = UIBarButtonItem(image: UIImage(named: "accept.png"), style: .plain, target: self, action: #selector(POISaveBtn_Clicked))
        self.navigationItem.rightBarButtonItem = saveBtn
        saveBtn.tintColor = .white
        
        // check notification of keyboard - to show or not
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // programmatically add radio buttons
        // first radio button
        let frameFirst = CGRect(x: self.view.frame.size.width / 2 - 131, y: height - 200, width: 162, height: 17);
        let firstRadioButton = createRadioButton(frame: frameFirst, title: point_passthru_str, color: UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00))
        let frameSecond = CGRect(x: self.view.frame.size.width / 2 - 131 + 100, y: height - 200, width: 162, height: 17);
        let secondRadioButton = createRadioButton(frame: frameSecond, title: point_interest_str, color: UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00))
        firstRadioButton.isEnabled = true
        // second radio button
        secondRadioButton.isIconOnRight = false
        
        if !isNewPOI {
            let poiQuery = PFQuery(className: "tripsegmentpoi")
            poiQuery.whereKey("poiuuid", equalTo: poiuuid.last!)
            poiQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    for object in objects! {
                        self.POINameTxt.text = object["poiname"] as! String?
                        self.POIDescTxt.text = object["poidescription"] as! String?
                        self.POICommentTxtView.text = object["poidetails"] as! String?
                        let point = object["location"] as! PFGeoPoint
                        self.POILatitudeTxt.text = "\(point.latitude)"
                        self.POILongitudeTxt.text = "\(point.longitude)"
                        let poitype = object["poitype"] as! Int?
                        self.pointtype = poitype!
                        if poitype == 0 {
                            self.POITypeBtn.setTitle(point_passthru_str, for: UIControlState.normal)
                            self.POILatLongFrameView.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
                            self.POITypeBtn.selected()?.titleLabel?.text = point_passthru_str
                            self.POITypeBtn.titleLabel?.text = point_passthru_str
                        } else {
                            self.POITypeBtn.setTitle(point_interest_str, for: UIControlState.normal)
                            self.POILatLongFrameView.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
                            self.POITypeBtn.selected()?.titleLabel?.text = point_interest_str
                            self.POITypeBtn.selectedButtons().first?.isEnabled = false
                            self.POITypeBtn.titleLabel?.text = point_interest_str
                            self.POITypeBtn.selectedButtons().last?.isSelected = true
                        }
                        
                        if self.pointtype == 0 {
                            firstRadioButton.isSelected = true
                            secondRadioButton.isSelected = false
                        } else {
                            firstRadioButton.isSelected = false
                            secondRadioButton.isSelected = true
                        }
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        } else {
            POILatitudeTxt.text = "\(0.00)"
            POILongitudeTxt.text = "\(0.00)"
        }
        
        // set textview parameters
        POICommentTxtView.backgroundColor = UIColor(colorLiteralRed: 242.0 / 255, green: 242.0 / 255, blue: 242.0 / 255, alpha: 1)
        POICommentTxtView.layer.cornerRadius = 5.0
        POICommentTxtView.clipsToBounds = true
        
        // enable multiple selection for spent types
        POITypeBtn.isMultipleSelectionEnabled = true
        
        if pointtype == 0 {
            firstRadioButton.isSelected = true
            secondRadioButton.isSelected = false
        } else {
            firstRadioButton.isSelected = false
            secondRadioButton.isSelected = true
        }
        
        secondRadioButton.contentHorizontalAlignment = .center
        firstRadioButton.contentHorizontalAlignment = .center
        firstRadioButton.otherButtons = [secondRadioButton]
        POITypeBtn.isUserInteractionEnabled = isOwner
        firstRadioButton.isUserInteractionEnabled = isOwner
        secondRadioButton.isUserInteractionEnabled = isOwner
        
        // localize button and label text
        POINameLbl.text = poi_name_str
        POIDescLbl.text = poi_description_str
        POICommentLbl.text = poi_comment_str
        POILatitudeLbl.text = latitude_str
        POILongitudeLbl.text = longitude_str
        POIActualPositionBtn.setTitle(get_actual_position_str, for: .normal)

        // add constraints programaticaly
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        addConstraints()
        
        // initialize poiview background color
        getPOIType()
    }
    
    func addConstraints() {
        
        POINameLbl.translatesAutoresizingMaskIntoConstraints = false
        POINameTxt.translatesAutoresizingMaskIntoConstraints = false
        POIDescLbl.translatesAutoresizingMaskIntoConstraints = false
        POIDescTxt.translatesAutoresizingMaskIntoConstraints = false
        POICommentLbl.translatesAutoresizingMaskIntoConstraints = false
        POICommentTxtView.translatesAutoresizingMaskIntoConstraints = false
        POILatitudeLbl.translatesAutoresizingMaskIntoConstraints = false
        POILatitudeTxt.translatesAutoresizingMaskIntoConstraints = false
        POILongitudeLbl.translatesAutoresizingMaskIntoConstraints = false
        POILongitudeTxt.translatesAutoresizingMaskIntoConstraints = false
        POITypeBtn.translatesAutoresizingMaskIntoConstraints = false
        POILatLongFrameView.translatesAutoresizingMaskIntoConstraints = false
        POIActualPositionBtn.translatesAutoresizingMaskIntoConstraints = false

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poinamelbl(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poinamelbl":POINameLbl]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poiname(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poiname":POINameTxt]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poidesclbl(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poidesclbl":POIDescLbl]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poidesc(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poidesc":POIDescTxt]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poicommentlbl(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poicommentlbl":POICommentLbl]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poicomment(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poicomment":POICommentTxtView]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poitype(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poitype":POITypeBtn]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[poinamelbl(15)]-10-[poiname(20)]-10-[poidesclbl(15)]-10-[poidesc(20)]-10-[poicommlbl(15)]-10-[poicomm(\(height - 540))]-10-[poiview(150)]",
            options: [],
            metrics: nil,
            views: ["poinamelbl":POINameLbl,"poiname":POINameTxt,"poidesclbl":POIDescLbl,"poidesc":POIDescTxt,"poicommlbl":POICommentLbl,"poicomm":POICommentTxtView,"poiview":POILatLongFrameView]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[poitype(30)]",
            options: [],
            metrics: nil,
            views: ["poitype":POITypeBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poiview(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poiview":POILatLongFrameView]))
        
        POILatLongFrameView.layer.cornerRadius = 5.0
        POILatLongFrameView.layer.masksToBounds = true
        POILatLongFrameView.frame = CGRect(x: 0, y: 0, width: width - 20, height: 190)
        POILatLongFrameView.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
        POILatLongFrameView.tintColor = .white
        self.view.addSubview(POILatLongFrameView)
        
        let poiLatLongView_width = POILatLongFrameView.frame.width
        
        self.POILatLongFrameView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poilatitudelbl(\(poiLatLongView_width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poilatitudelbl":POILatitudeLbl]))
        
        self.POILatLongFrameView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poilatitude(\(poiLatLongView_width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poilatitude":POILatitudeTxt]))
        
        self.POILatLongFrameView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poilongitudelbl(\(poiLatLongView_width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poilongitudelbl":POILongitudeLbl]))
        
        self.POILatLongFrameView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poilongitude(\(poiLatLongView_width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poilongitude":POILongitudeTxt]))

        self.POILatLongFrameView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[getlocbtn(\(poiLatLongView_width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["getlocbtn":POIActualPositionBtn]))

        self.POILatLongFrameView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[poilatitudelbl(15)]-10-[poilatitude(20)]-10-[poilongitudelbl(15)]-10-[poilongitude(20)]-10-[getlocbtn(20)]-10-|",
            options: [],
            metrics: nil,
            views: ["poilatitudelbl":POILatitudeLbl,"poilatitude":POILatitudeTxt,"poilongitudelbl":POILongitudeLbl,"poilongitude":POILongitudeTxt,"getlocbtn":POIActualPositionBtn]))
    }

    // find user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let locValue:CLLocationCoordinate2D = location.coordinate
            curLocationLatitude = locValue.latitude
            curLocationLongitude = locValue.longitude
        }
    }
    
    // location faild during finding user location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    //if we have no permission to access user location, then ask user for permission.
    func isAuthorizedtoGetUserLocation() {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            manager.requestWhenInUseAuthorization()
        }
    }

    // initrializing radiobuttons
    private func createRadioButton(frame : CGRect, title : String, color : UIColor) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame)
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        radioButton.setTitle(title, for: UIControlState.normal)
        radioButton.setTitleColor(color, for: UIControlState.normal)
        radioButton.iconColor = color
        radioButton.indicatorColor = color
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        radioButton.addTarget(self, action: #selector(logSelectedButton), for: UIControlEvents.touchUpInside)
        self.view.addSubview(radioButton)
        
        return radioButton
    }
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                if button.titleLabel!.text! == point_passthru_str {
                    POILatLongFrameView.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
                    pointtype = 0
                } else {
                    POILatLongFrameView.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
                    pointtype = 1
                }
            }
        } else {
            if radioButton.titleLabel!.text! == point_passthru_str {
                POILatLongFrameView.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
                pointtype = 0
            } else {
                POILatLongFrameView.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
                pointtype = 1
            }
        }
    }
    
    // func when keyboard is shown
    func keyboardWillShow (notification: NSNotification) {
        
        // define keyboard frame size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        
        // move up with animation
        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height
        }
    }
    
    // func when keyboard is hidden
    func keyboardWillHide (notification: NSNotification) {
        
        // move down with animation
        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentSize.height = 0
        }
    }

    // func to hide keyboard
    func hideKeyboard () {
        self.view.endEditing(true)
    }
    
    // go back function
    func back(sender: UIBarButtonItem) {
        //push back
        self.performSegueToReturnBack()
        //self.dismiss(animated: true, completion: nil)
    }

    // get data from selected POI from the POIs list
    func getPOIType() {
        
        if pointtype == 0 {
            POILatLongFrameView.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
        } else {
            POILatLongFrameView.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
        }
    }
    
    // save POI coordinates to server
    func POISaveBtn_Clicked() {
        // get count of objects
        var number : Int = 0
        let query = PFQuery(className:"tripsegmentpoi")
        query.whereKey("poiuuid", equalTo: poiuuid.last!)
        query.countObjectsInBackground { (counts: Int32, error: Error?) in
            if error == nil {
                number = Int(counts)
            }
        }
        
        if self.isNewPOI {
            let poiObj = PFObject(className: "tripsegmentpoi")
            poiObj["poiname"] = POINameTxt.text
            poiObj["poidescription"] = POIDescTxt.text
            poiObj["poidetails"] = POICommentTxtView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            poiObj["poitype"] = pointtype
            let point = PFGeoPoint(latitude: Double(POILatitudeTxt.text!)!, longitude: Double(POILongitudeTxt.text!)!)
            poiObj["location"] = point
            poiObj["uuid"] = postuuid.last!
            let uuid = UUID().uuidString
            poiObj["poiuuid"] = "\(PFUser.current()?.username) \(uuid)"
            if number == 0 {
                poiObj["poiorder"] = number
            } else {
                poiObj["poiorder"] = number - 1
            }
            
            poiObj.saveInBackground(block: { (success:Bool, error:Error?) in
                if error == nil {
                    if success {
                        // refreshing function
                        // send notification if we liked to refresh TableView
                        self.performSegueToReturnBack()
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "save"), object: nil)
                    } else {
                        print(error!.localizedDescription)
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        // updating already created and saved POI
        } else {
            let queryObj = PFQuery(className: "tripsegmentpoi")
            queryObj.whereKey("poiuuid", equalTo: poiuuid.last!)
            queryObj.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    for object in objects! {
                        object["poiname"] = self.POINameTxt.text
                        object["poidescription"] = self.POIDescTxt.text
                        object["poidetails"] = self.POICommentTxtView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                        object["poitype"] = self.pointtype
                        let point = PFGeoPoint(latitude: Double(self.POILatitudeTxt.text!)!, longitude: Double(self.POILongitudeTxt.text!)!)
                        object["location"] = point
                        object["uuid"] = postuuid.last!
                        object.saveInBackground(block: { (success: Bool, error: Error?) in
                            if success {
                                // return back
                                self.performSegueToReturnBack()
                                
                                // refreshing function
                                // send notification if we liked to refresh TableView
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "save"), object: nil)

                            } else {
                                print(error!.localizedDescription)
                            }
                        })
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    
    @IBAction func POIActualPositionBtn_Clicked(_ sender: Any) {
        // get actual location
        POILatitudeTxt.text = "\(curLocationLatitude)"
        POILongitudeTxt.text = "\(curLocationLongitude)"
        
        // to save battery
        // manager.stopUpdatingLocation()
    }
}
