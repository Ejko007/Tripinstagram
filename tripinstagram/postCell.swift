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

class postCell: UITableViewCell {
    
    
    @IBOutlet weak var tripNameLbl: UILabel!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var picImg: UIImageView!
    
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var commentNrLbl: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var titleLbl: KILabel!
    @IBOutlet weak var uuidLbl: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var fromStrLbl: UILabel!
    @IBOutlet weak var toStrLbl: UILabel!
    @IBOutlet weak var fromDateLbl: UILabel!
    @IBOutlet weak var toDateLbl: UILabel!
    @IBOutlet weak var nrPersonsIcon: UIImageView!
    @IBOutlet weak var nrPersonsLbl: UILabel!
    @IBOutlet weak var levelIcon: UIImageView!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var spentsIcon: UIImageView!
    @IBOutlet weak var totalSpentsLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var mapmarkerIcon: UIImageView!
    @IBOutlet weak var totalDistanceLbl: UILabel!
    @IBOutlet weak var kmLbl: UILabel!
    @IBOutlet weak var countriesView: UIView!
    
    //let pictureWidth = width - 20
    let pictureWidth = UIScreen.main.bounds.width / 2

    // default function
    override func awakeFromNib() {
        super.awakeFromNib()
                
        // set rate controller to precise
        rateView!.settings.fillMode = .precise
        rateView!.updateOnTouch = true
        let rateTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_ :)))
        rateView.addGestureRecognizer(rateTap)
         
        // clear like title button color
        likeBtn.setTitleColor(UIColor.clear, for: .normal)

        // enable second tap to zoom picture
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(zoomImg))
        zoomTap.numberOfTapsRequired = 2
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)

        let width = UIScreen.main.bounds.width
        
        // allow constraints
        tripNameLbl.translatesAutoresizingMaskIntoConstraints = false
        avaImg.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        picImg.translatesAutoresizingMaskIntoConstraints = false
        likeBtn.translatesAutoresizingMaskIntoConstraints = false
        commentBtn.translatesAutoresizingMaskIntoConstraints = false
        commentNrLbl.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        likeLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        uuidLbl.translatesAutoresizingMaskIntoConstraints = false
        rateView.translatesAutoresizingMaskIntoConstraints = false
        mainContentView.translatesAutoresizingMaskIntoConstraints = false
        fromStrLbl.translatesAutoresizingMaskIntoConstraints = false
        fromDateLbl.translatesAutoresizingMaskIntoConstraints = false
        toStrLbl.translatesAutoresizingMaskIntoConstraints = false
        toDateLbl.translatesAutoresizingMaskIntoConstraints = false
        nrPersonsIcon.translatesAutoresizingMaskIntoConstraints = false
        nrPersonsLbl.translatesAutoresizingMaskIntoConstraints = false
        levelIcon.translatesAutoresizingMaskIntoConstraints = false
        levelLbl.translatesAutoresizingMaskIntoConstraints = false
        spentsIcon.translatesAutoresizingMaskIntoConstraints = false
        totalSpentsLbl.translatesAutoresizingMaskIntoConstraints = false
        currencyLbl.translatesAutoresizingMaskIntoConstraints = false
        mapmarkerIcon.translatesAutoresizingMaskIntoConstraints = false
        totalDistanceLbl.translatesAutoresizingMaskIntoConstraints = false
        kmLbl.translatesAutoresizingMaskIntoConstraints = false
        countriesView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[mainview]-|",
            options: [],
            metrics: nil, views: ["mainview":mainContentView]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[mainview]-|",
            options: [],
            metrics: nil, views: ["mainview":mainContentView]))
                
        self.mainContentView.backgroundColor = UIColor(red: 155 / 255, green: 155 / 255, blue: 155 / 255, alpha: 3 / 100)
        self.mainContentView.layer.cornerRadius = 8
        self.mainContentView.clipsToBounds = true
        self.mainContentView.layer.masksToBounds = false
        self.mainContentView.layer.shadowColor = UIColor.darkGray.cgColor
        self.mainContentView.layer.shadowOpacity = 1
        self.mainContentView.layer.shadowOffset = CGSize.zero
        self.mainContentView.layer.shadowRadius = 10
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[ava(30)]-10-[tripname(23)]-10-[pic(\(pictureWidth))]-5-[like(30)]-5-[spenticon(30)]-5-[countries(15)]-5-[titletxt]-|",
            options: [],
            metrics: nil, views: ["ava":avaImg, "tripname":tripNameLbl ,"pic":picImg, "like": likeBtn, "spenticon":spentsIcon, "countries":countriesView, "titletxt":titleLbl]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[username(30)]-10-[tripname(23)]-10-[fromstr]-5-[fromdate]-10-[tostr]-5-[todate]-10-[nrpersonicon(30)]-10-[rating(30)]",
            options: [],
            metrics: nil, views: ["username":usernameBtn, "tripname":tripNameLbl ,"fromstr":fromStrLbl, "fromdate": fromDateLbl, "tostr":toStrLbl, "todate":toDateLbl, "nrpersonicon":nrPersonsIcon, "rating":rateView]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[todate]-15-[nrpersons]",
            options: [],
            metrics: nil, views: ["todate":toDateLbl, "nrpersons":nrPersonsLbl]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[todate]-10-[levelicon(30)]",
            options: [],
            metrics: nil, views: ["todate":toDateLbl, "levelicon":levelIcon]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[todate]-15-[level]",
            options: [],
            metrics: nil, views: ["todate":toDateLbl, "level":levelLbl]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-5-[likesnr(30)]",
            options: [],
            metrics: nil, views: ["pic":picImg, "likesnr":likeLbl]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-5-[comment(30)]-10-[totalspents]",
            options: [],
            metrics: nil, views: ["pic":picImg, "comment":commentBtn, "totalspents":totalSpentsLbl]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-5-[comment(30)]-10-[currency]",
            options: [],
            metrics: nil, views: ["pic":picImg, "comment":commentBtn, "currency":currencyLbl]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[comment(30)]-5-[distanceicon(30)]",
            options: [],
            metrics: nil, views: ["comment":commentBtn, "distanceicon":mapmarkerIcon]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[comment(30)]-10-[distance]",
            options: [],
            metrics: nil, views: ["comment":commentBtn, "distance":totalDistanceLbl]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[comment(30)]-10-[kmlbl]",
            options: [],
            metrics: nil, views: ["comment":commentBtn, "kmlbl":kmLbl]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-10-[comments]",
            options: [],
            metrics: nil, views: ["pic":picImg, "comments":commentNrLbl]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-15-[date]",
            options: [],
            metrics: nil, views: ["date":dateLbl]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-5-[more(30)]",
            options: [],
            metrics: nil, views: ["pic":picImg, "more":moreBtn]))
        
        // horizontal alignement
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[ava(30)]-10-[username]-10-[datelbl(30)]-10-|",
            options: [],
            metrics: nil, views: ["ava":avaImg, "username":usernameBtn, "datelbl":dateLbl]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[tripname]-10-|",
            options: [],
            metrics: nil, views: ["tripname":tripNameLbl]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-10-[fromstr]",
            options: [],
            metrics: nil, views: ["pic":picImg, "fromstr":fromStrLbl]))
 
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-10-[fromdate]",
            options: [],
            metrics: nil, views: ["pic":picImg, "fromdate":fromDateLbl]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-10-[tostr]",
            options: [],
            metrics: nil, views: ["pic":picImg, "tostr":toStrLbl]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-10-[todate]",
            options: [],
            metrics: nil, views: ["pic":picImg, "todate":toDateLbl]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[nrpersonicon(30)]-5-[nrpersons(20)]-10-[levelicon(30)]-5-[level(20)]-10-|",
            options: [],
            metrics: nil, views: ["nrpersonicon":nrPersonsIcon, "nrpersons":nrPersonsLbl, "levelicon":levelIcon, "level":levelLbl]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-10-[rates]-10-|",
            options: [],
            metrics: nil, views: ["pic":picImg, "rates":rateView]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[like(30)]-5-[likes(30)]-10-[comment(30)]-5-[comments(30)]",
            options: [],
            metrics: nil, views: ["like": likeBtn, "likes": likeLbl, "comment":commentBtn, "comments":commentNrLbl]))
 
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[more(30)]-10-|",
            options: [],
            metrics: nil, views: ["more":moreBtn]))
        
        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[spentsicon(30)]-10-[spents]-5-[currency]",
            options: [],
            metrics: nil, views: ["spentsicon":spentsIcon,"spents":totalSpentsLbl,"currency":currencyLbl]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-[mapmarker(30)]-10-[distance]-5-[kmlbl]",
            options: [],
            metrics: nil, views: ["pic":picImg,"mapmarker":mapmarkerIcon, "distance":totalDistanceLbl, "kmlbl":kmLbl]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[countries]-10-|",
            options: [],
            metrics: nil, views: ["countries": countriesView]))

        self.mainContentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[title]-10-|",
            options: [],
            metrics: nil, views: ["title": titleLbl]))

        
        // round trip name frame
        tripNameLbl.layer.cornerRadius = 3
        tripNameLbl.clipsToBounds = true
        tripNameLbl.frame.size = CGSize(width: width - 40, height: 25)
        tripNameLbl.backgroundColor = UIColor(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 30 / 100)
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        // create hidden button over rateView
        rateView.backgroundColor = .clear
        rateView.starSize = 15
        
        // countries view settings
        countriesView.backgroundColor = UIColor(white: 1, alpha: 0)
        
     }
    
    // clicked like button
    @IBAction func likeBtn_click(_ sender: AnyObject) {
        
        // declare title of button
        let title = sender.title(for: .normal)
        
        // to like
        if title == "unlike" {
            
            let object = PFObject(className: "likes")
            object["by"] = PFUser.current()?.username!
            object["to"] = uuidLbl.text
            object.saveInBackground(block: { (success: Bool, error: Error?) in
                if success {
                    
                    self.likeBtn.setTitle("like", for: UIControlState.normal)
                    self.likeBtn.setBackgroundImage(UIImage(named: "like.png"), for: UIControlState.normal)
                    
                    // send notification if we liked to refresh TableView
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
                    
                    // send notification as like
                    if self.usernameBtn.titleLabel?.text != PFUser.current()?.username {
                        let newsObj = PFObject(className: "news")
                        newsObj["by"] = PFUser.current()?.username
                        newsObj["gender"] = PFUser.current()?.object(forKey: "gender") as! String
                        newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
                        newsObj["to"] = self.usernameBtn.titleLabel!.text
                        newsObj["owner"] = self.usernameBtn.titleLabel!.text
                        newsObj["uuid"] = self.uuidLbl.text
                        newsObj["type"] = "like"
                        newsObj["checked"] = "no"
                        newsObj.saveEventually()
                    }
                }
            })
        // to dislike
        } else {
        
            // request existing likes of current user to show post
            let query = PFQuery(className: "likes")
            query.whereKey("by", equalTo: PFUser.current()!.username!)
            query.whereKey("to", equalTo: uuidLbl.text!)
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    // find objects - likes
                    for object in objects! {
                        
                        // delete found like
                        object.deleteInBackground(block: { (success: Bool, error: Error?) in
                            if error == nil {
                                if success {
                                
                                    self.likeBtn.setTitle("unlike", for: UIControlState.normal)
                                    self.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), for: .normal)
                                    
                                    // send notification if we liked to refresh TableView
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "liked"), object: nil)
                                    
                                    // delete like notification
                                    let newsQuery = PFQuery(className: "news")
                                    newsQuery.whereKey("by", equalTo: PFUser.current()!.username!)
                                    newsQuery.whereKey("to", equalTo: self.usernameBtn.titleLabel!.text!)
                                    newsQuery.whereKey("uuid", equalTo: self.uuidLbl.text!)
                                    newsQuery.whereKey("type", equalTo: "like")
                                    newsQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                                        if error == nil {
                                            for object in objects! {
                                                object.deleteEventually()
                                            }
                                        } else {
                                            print(error!.localizedDescription)
                                        }
                                    })
                                }
                                
                            } else {
                                print (error!.localizedDescription)
                            }
                            
                            
                        })
                        
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    
    // zooming in/out function
    func zoomImg () {
        
        // define frame of zoomed image
        let zoomed = CGRect(x: 0, y: self.mainContentView.center.y - self.mainContentView.center.x, width: self.mainContentView.frame.size.width, height: self.mainContentView.frame.size.width)

        // frame of unzoomed (small) image
        //let unzoomed = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
        let unzoomed = CGRect(x: 10, y: 83, width: pictureWidth, height: pictureWidth)
        
        // id picture is unzoomed, zoom it
        if picImg.frame == unzoomed {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.picImg.frame = zoomed
                
                // hide objects from background
                self.mainContentView.backgroundColor = .black
                self.tripNameLbl.alpha = 0
                self.avaImg.alpha = 0
                self.usernameBtn.alpha = 0
                self.dateLbl.alpha = 0
                self.likeBtn.alpha = 0
                self.commentBtn.alpha = 0
                self.commentNrLbl.alpha = 0
                self.moreBtn.alpha = 0
                self.likeLbl.alpha = 0
                self.titleLbl.alpha = 0
                self.uuidLbl.alpha = 0
                self.rateView.alpha = 0
                self.fromStrLbl.alpha = 0
                self.toStrLbl.alpha = 0
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
                
                self.picImg.frame = unzoomed
                
                // unhide objects from background
                self.mainContentView.backgroundColor = .white
                self.tripNameLbl.alpha = 1
                self.avaImg.alpha = 1
                self.usernameBtn.alpha = 1
                self.dateLbl.alpha = 1
                self.likeBtn.alpha = 1
                self.commentBtn.alpha = 1
                self.commentNrLbl.alpha = 1
                self.moreBtn.alpha = 1
                self.likeLbl.alpha = 1
                self.titleLbl.alpha = 1
                self.uuidLbl.alpha = 1
                self.rateView.alpha = 1
                self.fromStrLbl.alpha = 1
                self.toStrLbl.alpha = 1
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
                self.mainContentView.backgroundColor = UIColor(red: 155 / 255, green: 155 / 255, blue: 155 / 255, alpha: 3 / 100)
                self.mainContentView.layer.cornerRadius = 8
                self.mainContentView.clipsToBounds = true
                self.mainContentView.layer.masksToBounds = false
                self.mainContentView.layer.shadowColor = UIColor.darkGray.cgColor
                self.mainContentView.layer.shadowOpacity = 1
                self.mainContentView.layer.shadowOffset = CGSize.zero
                self.mainContentView.layer.shadowRadius = 10

            })
        }
    }
    
    func handleTap(_ sender: AnyObject) {
        print("hello world")
        
    }
}
