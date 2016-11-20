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
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var isPublished: UISwitch!
    

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
        
        // allow constraints
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
        
        let pictureWidth = width - 20
        
        // cnstraints
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[ava(30)]-10-[pic(\(pictureWidth))]-5-[like(30)]",
            options: [],
            metrics: nil, views: ["ava":avaImg, "pic":picImg, "like": likeBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[username]",
            options: [],
            metrics: nil, views: ["username":usernameBtn]))
         
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-5-[comment(30)]",
            options: [],
            metrics: nil, views: ["pic":picImg, "comment":commentBtn]))
 
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-10-[comments(15)]",
            options: [],
            metrics: nil, views: ["pic":picImg, "comments":commentNrLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-15-[date]",
            options: [],
            metrics: nil, views: ["date":dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[like]-5-[title]-5-|",
            options: [],
            metrics: nil, views: ["like":likeBtn, "title": titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-5-[more(30)]",
            options: [],
            metrics: nil, views: ["pic":picImg, "more": moreBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-10-[likes]",
            options: [],
            metrics: nil, views: ["pic":picImg, "likes": likeLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-10-[rates]",
            options: [],
            metrics: nil, views: ["pic":picImg, "rates": rateView]))
    
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[ava(30)]-10-[username]",
            options: [],
            metrics: nil, views: ["ava":avaImg, "username":usernameBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[pic]-10-|",
            options: [],
            metrics: nil, views: ["pic":picImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[like(30)]-5-[likes]-25-[comment(30)]-5-[comments]-25-[rates]",
            options: [],
            metrics: nil, views: ["like": likeBtn, "likes": likeLbl, "comment":commentBtn, "comments":commentNrLbl, "rates":rateView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[more(30)]-10-|",
            options: [],
            metrics: nil, views: ["more":moreBtn]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[title]-10-|",
            options: [],
            metrics: nil, views: ["title": titleLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[date]-10-|",
            options: [],
            metrics: nil, views: ["date": dateLbl]))
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        // create hidden button over rateView
        rateBtn.frame = CGRect(x: rateView!.frame.origin.x, y: rateView!.frame.origin.y, width: rateView!.frame.width, height: rateView!.frame.height)
        rateBtn.setTitle("", for: .normal)
        rateBtn.setTitleColor(.clear, for: .normal)
        rateBtn.backgroundColor = .clear
        rateBtn.tintColor = .clear
        
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
                                print (error?.localizedDescription as Any)
                            }
                            
                            
                        })
                        
                    }
                } else {
                    print(error?.localizedDescription as Any)
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
