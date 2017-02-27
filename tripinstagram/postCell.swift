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

class postCell: UITableViewCell {
    
    
    @IBOutlet weak var postUserView: UIView!
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    
    @IBOutlet weak var picImg: UIImageView!
    
    @IBOutlet weak var uuidLbl: UILabel!
    
    @IBOutlet weak var postDateView: UIView!
    @IBOutlet weak var fromDateStrLbl: UILabel!
    @IBOutlet weak var calendarIcon: UIImageView!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var toDateStrLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    
    @IBOutlet weak var nrPersonsIcon: UIImageView!
    @IBOutlet weak var nrPersonsLbl: UILabel!
    @IBOutlet weak var levelIcon: UIImageView!
    @IBOutlet weak var levelLbl: UILabel!
    
    @IBOutlet weak var zoomin: UIButton!
    @IBOutlet weak var postFinAndDestView: UIView!
    @IBOutlet weak var spentsIcon: UIImageView!
    @IBOutlet weak var totalSpentsLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var mapmarkerIcon: UIImageView!
    @IBOutlet weak var totalDistanceLbl: UILabel!
    @IBOutlet weak var kmLbl: UILabel!
    @IBOutlet weak var countriesView: UIView!
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var postMapView: MKMapView!
    
    
    //let pictureWidth = width - 20
    let pictureWidth = UIScreen.main.bounds.width
    let pictureHeight = round(UIScreen.main.bounds.height / 3) + 50
    
    var MapViewLocationManager:CLLocationManager! = CLLocationManager()
    var currentLoc: PFGeoPoint! = PFGeoPoint()

    // default function
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
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
        self.contentView.layer.cornerRadius = 8
        self.contentView.clipsToBounds = true
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowColor = UIColor.darkGray.cgColor
        self.contentView.layer.shadowOpacity = 1
        self.contentView.layer.shadowOffset = CGSize.zero
        self.contentView.layer.shadowRadius = 10

        
        // set opacity for postFinAndDestView
        postFinAndDestView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        totalSpentsLbl.textColor = UIColor.white
        currencyLbl.textColor = UIColor.white
        totalDistanceLbl.textColor = UIColor.white
        kmLbl.textColor = UIColor.white
        
        // change color of button image
        let origImage = UIImage(named: "zoom_in")
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        zoomin.setImage(tintedImage, for: .normal)
        zoomin.tintColor = .white
        
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
            withVisualFormat: "V:|-5-[calendaricon(30)]-5-|",
            options: [],
            metrics: nil, views: ["calendaricon":calendarIcon]))

        self.postDateView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[todatestrlbl]-5-|",
            options: [],
            metrics: nil, views: ["todatestrlbl":toDateStrLbl]))

        self.postDateView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[todatelbl]-5-|",
            options: [],
            metrics: nil, views: ["todatelbl":toDateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[usernameview]-(-40)-[pic(\(pictureHeight))]-(\(-pictureHeight))-[pictureview]-(-40)-[postfindestbarview]-0-[postdateview]-0-[mapview(\(UIScreen.main.bounds.height - pictureHeight - 40 - (44 + 49 + UIApplication.shared.statusBarFrame.height)))]-|",
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
            withVisualFormat: "H:|-10-[fromdatestrlbl(20)]-10-[fromdatelbl(\((pictureWidth / 2) - 75))]-20-[calendaricon(30)]-20-[todatestrlbl(20)]-10-[todatelbl(\((pictureWidth / 2) - 75))]-10-|",
            options: [],
            metrics: nil, views: ["fromdatestrlbl":fromDateStrLbl, "fromdatelbl":fromDateLbl, "calendaricon":calendarIcon, "todatestrlbl":toDateStrLbl, "todatelbl":toDateLbl]))
        
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
     }
    
    // zooming in/out function
    func zoomImg () {
        
        // define frame of zoomed image
        let zoomed = CGRect(x: 0, y: self.contentView.center.y - self.contentView.center.x, width: self.contentView.frame.size.width, height: self.contentView.frame.size.width)

        // frame of unzoomed (small) image
        //let unzoomed = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
        let unzoomed = CGRect(x: 10, y: 83, width: pictureWidth, height: pictureWidth)
        
        // id picture is unzoomed, zoom it
        if picImg.frame == unzoomed {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.zoomin.setImage(UIImage(named: "zoom_in.png"), for: UIControlState.normal)
                
                self.picImg.frame = zoomed
                
                // hide objects from background
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
                
            })
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.zoomin.setImage(UIImage(named: "zoom_out.png"), for: UIControlState.normal)
                
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
                
                // add customized graphics to cell
                self.contentView.backgroundColor = UIColor(red: 155 / 255, green: 155 / 255, blue: 155 / 255, alpha: 3 / 100)
                self.contentView.layer.cornerRadius = 8
                self.contentView.clipsToBounds = true
                self.contentView.layer.masksToBounds = false
                self.contentView.layer.shadowColor = UIColor.darkGray.cgColor
                self.contentView.layer.shadowOpacity = 1
                self.contentView.layer.shadowOffset = CGSize.zero
                self.contentView.layer.shadowRadius = 10

            })
        }
    }
    
    @IBAction func zoomBtnClicked(_ sender: Any) {
        
       zoomImg()
        
    }
    
    
}
