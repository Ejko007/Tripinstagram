//
//  tripDetailMapPOIVC.swift
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

class tripDetailMapPOIVC: UIViewController {

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
    @IBOutlet weak var POISaveBtn: UIButton!
    @IBOutlet weak var POITypeBtn: DLRadioButton!
    @IBOutlet weak var POILatLongFrameView: UIView!
    
    
    var pointtype : Int = 0
    
    // size of screen
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var isOwner = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if PFUser.current()?.username!.lowercased() == username.lowercased() {
//            isOwner = true
//        }

        // navigation bar title
        self.navigationItem.title = trip_point.uppercased()

        // hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // set textview parameters
        POICommentTxtView.backgroundColor = UIColor(colorLiteralRed: 242.0 / 255, green: 242.0 / 255, blue: 242.0 / 255, alpha: 1)
        POICommentTxtView.layer.cornerRadius = 5.0
        POICommentTxtView.clipsToBounds = true
        
        // enable multiple selection for spent types
        POITypeBtn.isMultipleSelectionEnabled = true
        
        // programmatically add radio buttons
        // first radio button
        let frameFirst = CGRect(x: self.view.frame.size.width / 2 - 131, y: height - 200, width: 162, height: 17);
        let firstRadioButton = createRadioButton(frame: frameFirst, title: point_passthru_str, color: UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00))
        let frameSecond = CGRect(x: self.view.frame.size.width / 2 - 131 + 100, y: height - 200, width: 162, height: 17);
        let secondRadioButton = createRadioButton(frame: frameSecond, title: point_interest_str, color: UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00))
        firstRadioButton.isEnabled = true
        // second radio button
        secondRadioButton.isIconOnRight = false
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
        POISaveBtn.setTitle(save_str,for: .normal)

        // add constraints programaticaly
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
        POISaveBtn.translatesAutoresizingMaskIntoConstraints = false
        POITypeBtn.translatesAutoresizingMaskIntoConstraints = false
        POILatLongFrameView.translatesAutoresizingMaskIntoConstraints = false
        
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
            withVisualFormat: "H:|-10-[poisave(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poisave":POISaveBtn]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[poinamelbl(15)]-10-[poiname(20)]-10-[poidesclbl(15)]-10-[poidesc(20)]-10-[poicommlbl(15)]-10-[poicomm(\(height - 520))]-10-[poiview(140)]",
            options: [],
            metrics: nil,
            views: ["poinamelbl":POINameLbl,"poiname":POINameTxt,"poidesclbl":POIDescLbl,"poidesc":POIDescTxt,"poicommlbl":POICommentLbl,"poicomm":POICommentTxtView,"poiview":POILatLongFrameView]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[poitype]-20-[poisave]-10-|",
            options: [],
            metrics: nil,
            views: ["poitype":POITypeBtn,"poisave":POISaveBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poiview(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poiview":POILatLongFrameView]))
        
        POILatLongFrameView.layer.cornerRadius = 5.0
        POILatLongFrameView.layer.masksToBounds = true
        POILatLongFrameView.frame = CGRect(x: 0, y: 0, width: width - 20, height: 140)
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
            withVisualFormat: "V:|-10-[poilatitudelbl(20)]-10-[poilatitude(20)]-10-[poilongitudelbl(20)]-10-[poilongitude(20)]-10-|",
            options: [],
            metrics: nil,
            views: ["poilatitudelbl":POILatitudeLbl,"poilatitude":POILatitudeTxt,"poilongitudelbl":POILongitudeLbl,"poilongitude":POILongitudeTxt]))
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

    // hide keyboard func
    func hideKeyboardTap () {
        self.view.endEditing(true)
    }

    // get data from selected spent from the spents list
    func getPOIType() {
        
        if pointtype == 0 {
            POILatLongFrameView.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
        } else {
            POILatLongFrameView.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
        }
    }
    
    // save POI coordinates to server
    @IBAction func POISaveBtn_Clicked(_ sender: Any) {
        
        let poiObj = PFObject(className: "tripsegmentpoi")
        poiObj["poiname"] = POINameTxt.text
        poiObj["poidescription"] = POIDescTxt.text
        poiObj["poidetails"] = POICommentTxtView.text
        poiObj["poitype"] = pointtype
        let point = PFGeoPoint(latitude: Double(POILatitudeTxt.text!)!, longitude: Double(POILongitudeTxt.text!)!)
        poiObj["location"] = point
        poiObj["uuid"] = postuuid.last!
        let uuid = UUID().uuidString
        poiObj["poiuuid"] = "\(PFUser.current()?.username) \(uuid)"
        
        poiObj.saveInBackground(block: { (success:Bool, error:Error?) in
            if error == nil {
                if success {
//                    let okbtn = DefaultButton(title: ok_str, action: nil)
//                    let complMenu = PopupDialog(title: annotation_str, message: annotation_save_confirm_str)
//                    complMenu.addButtons([okbtn])
//                    self.present(complMenu, animated: true, completion: nil)
                    
                    // switch to poi list view controller
                    // _ = self.navigationController?.popViewController(animated: true)
                    self.performSegueToReturnBack()
                    
                    // reset everything
                    self.viewDidLoad()
                    
                } else {
                    print(error!.localizedDescription)
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
}
