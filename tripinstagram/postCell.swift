//
//  postCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

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
    

    // default function
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set rate controller to precise
        rateView!.settings.fillMode = .precise
        rateView!.updateOnTouch = false
         
        // clear like title button color
        likeBtn.setTitleColor(UIColor.clear, for: .normal)
        
        // double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeTap.numberOfTapsRequired = 2
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(likeTap)

        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
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
        
        //let pictureWidth = width - 20
        let pictureWidth = width / 2
        
        // constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[mainview(\(height - 20 - 170))]-10-|",
            options: [],
            metrics: nil, views: ["mainview":mainContentView]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[mainview(\(width - 20))]-10-|",
            options: [],
            metrics: nil, views: ["mainview":mainContentView]))
        
        self.contentView.addSubview(mainContentView)
        
        //make dictionary for views
        let viewsDictionary = ["view1":mainContentView!]
        
        //sizing constraints for view
        let view1_constraint_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[view1]",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil, views: viewsDictionary)
        let view1_constraint_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[view1]",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil, views: viewsDictionary)
        
        mainContentView.addConstraints(view1_constraint_H)
        mainContentView.addConstraints(view1_constraint_V)
        mainContentView.backgroundColor = UIColor(red: 155 / 255, green: 155 / 255, blue: 155 / 255, alpha: 3 / 100)
        mainContentView.layer.cornerRadius = 8
        mainContentView.clipsToBounds = true
        mainContentView.layer.masksToBounds = false
        mainContentView.layer.shadowColor = UIColor.darkGray.cgColor
        mainContentView.layer.shadowOpacity = 1
        mainContentView.layer.shadowOffset = CGSize.zero
        mainContentView.layer.shadowRadius = 10
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[ava(30)]-10-[tripname(23)]-10-[pic(\(pictureWidth))]-5-[like(30)]",
            options: [],
            metrics: nil, views: ["ava":avaImg, "tripname":tripNameLbl ,"pic":picImg, "like": likeBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[username(30)]-10-[tripname(23)]-10-[fromstr]-5-[fromdate]-10-[tostr]-5-[todate]-10-[nrpersonicon(30)]",
            options: [],
            metrics: nil, views: ["username":usernameBtn, "tripname":tripNameLbl ,"fromstr":fromStrLbl, "fromdate": fromDateLbl, "tostr":toStrLbl, "todate":toDateLbl, "nrpersonicon":nrPersonsIcon]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[todate]-15-[nrpersons]",
            options: [],
            metrics: nil, views: ["todate":toDateLbl, "nrpersons":nrPersonsLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[todate]-10-[levelicon(30)]",
            options: [],
            metrics: nil, views: ["todate":toDateLbl, "levelicon":levelIcon]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[todate]-15-[level]",
            options: [],
            metrics: nil, views: ["todate":toDateLbl, "level":levelLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[username]",
            options: [],
            metrics: nil, views: ["username":usernameBtn]))
         
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-5-[comment(30)]-10-[totalspents]",
            options: [],
            metrics: nil, views: ["pic":picImg, "comment":commentBtn, "totalspents":totalSpentsLbl]))
 
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[comment(30)]-10-[currency]",
            options: [],
            metrics: nil, views: ["comment":commentBtn, "currency":currencyLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[comment(30)]-10-[distance]",
            options: [],
            metrics: nil, views: ["comment":commentBtn, "distance":totalDistanceLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[comment(30)]-10-[kmlbl]",
            options: [],
            metrics: nil, views: ["comment":commentBtn, "kmlbl":kmLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-10-[comments]",
            options: [],
            metrics: nil, views: ["pic":picImg, "comments":commentNrLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-15-[date]",
            options: [],
            metrics: nil, views: ["date":dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[like(30)]",
            options: [],
            metrics: nil, views: ["like":likeBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-5-[more(30)]",
            options: [],
            metrics: nil, views: ["pic":picImg, "more": moreBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-10-[likes]-10-[spentsicon(30)]-5-[title]-5-|",
            options: [],
            metrics: nil, views: ["pic":picImg, "likes": likeLbl, "spentsicon":spentsIcon, "title":titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-10-[likes]-10-[mapmarker(30)]",
            options: [],
            metrics: nil, views: ["pic":picImg, "likes": likeLbl, "mapmarker":mapmarkerIcon]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[personsicon]-10-[rates]",
            options: [],
            metrics: nil, views: ["personsicon":nrPersonsIcon, "rates": rateView]))
 
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[ava(30)]-10-[username]",
            options: [],
            metrics: nil, views: ["ava":avaImg, "username":usernameBtn]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[tripname(\(width - 40))]-10-|",
            options: [],
            metrics: nil, views: ["tripname":tripNameLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-10-[fromstr]-|",
            options: [],
            metrics: nil, views: ["pic":picImg, "fromstr":fromStrLbl]))
 
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-10-[fromdate]-|",
            options: [],
            metrics: nil, views: ["pic":picImg, "fromdate":fromDateLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-10-[nrpersonicon(30)]-10-[nrpersons]-10-[levelicon(30)]-10-[level]-|",
            options: [],
            metrics: nil, views: ["pic":picImg, "nrpersonicon":nrPersonsIcon, "nrpersons":nrPersonsLbl, "levelicon":levelIcon, "level":levelLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-10-[tostr]-|",
            options: [],
            metrics: nil, views: ["pic":picImg, "tostr":toStrLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-10-[todate]-|",
            options: [],
            metrics: nil, views: ["pic":picImg, "todate":toDateLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[like(30)]-5-[likes(30)]-10-[comment(30)]-5-[comments(30)]",
            options: [],
            metrics: nil, views: ["like": likeBtn, "likes": likeLbl, "comment":commentBtn, "comments":commentNrLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[pic(\(pictureWidth))]-10-[rates]-10-|",
            options: [],
            metrics: nil, views: ["pic":picImg, "rates":rateView]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[more(30)]-10-|",
            options: [],
            metrics: nil, views: ["more":moreBtn]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[title]-10-|",
            options: [],
            metrics: nil, views: ["title": titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[date]-10-|",
            options: [],
            metrics: nil, views: ["date": dateLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[spentsicon(30)]-10-[spents]-5-[currency]",
            options: [],
            metrics: nil, views: ["spentsicon":spentsIcon,"spents":totalSpentsLbl,"currency":currencyLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic(\(pictureWidth))]-[mapmarker(30)]-10-[distance]-5-[kmlbl]",
            options: [],
            metrics: nil, views: ["pic":picImg,"mapmarker":mapmarkerIcon, "distance":totalDistanceLbl, "kmlbl":kmLbl]))

        
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
    
    
    // double tap to like
    func likeTapped() {
        
        // create large like gray heart
        let likePic = UIImageView(image: UIImage(named: "unlike.png"))
        likePic.frame.size.width = picImg.frame.size.width / 1.5
        likePic.frame.size.height = picImg.frame.size.width / 1.5
        likePic.center = picImg.center
        likePic.alpha = 0.8
        self.addSubview(likePic)
        
        // hide likePic with animation and transform to be smaller
        UIView.animate(withDuration: 0.4) { 
            likePic.alpha = 0
            likePic.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        
        // declare title of button
        let title = likeBtn.title(for: .normal)
        
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
        }
    }
}
