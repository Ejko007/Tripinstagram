//
//  feedCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog

class feedCell: UITableViewCell {

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
    
    @IBOutlet weak var feedDefBarView: UIView!
    @IBOutlet weak var feedDateDefView: UIView!
    @IBOutlet weak var feedCommentView: UIView!
    
    //let pictureWidth = width - 20
    let pictureWidth = UIScreen.main.bounds.width
    let pictureHeight = UIScreen.main.bounds.height / 3
    
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
        fromStrLbl.translatesAutoresizingMaskIntoConstraints = false
        fromDateLbl.translatesAutoresizingMaskIntoConstraints = false
        toStrLbl.translatesAutoresizingMaskIntoConstraints = false
        toDateLbl.translatesAutoresizingMaskIntoConstraints = false
        feedDefBarView.translatesAutoresizingMaskIntoConstraints = false
        feedDateDefView.translatesAutoresizingMaskIntoConstraints = false
        feedCommentView.translatesAutoresizingMaskIntoConstraints = false
        
        // feeddef view opacity properties settings
        // feedDefBarView.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        feedDefBarView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        likeLbl.textColor = UIColor.white
        commentNrLbl.textColor = UIColor.white
        
        // feeddate view opacity properties settings
        feedDateDefView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // constraints
        // vertical constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[ava(30)]-10-[pic(\(pictureHeight))]-(-40)-[feeddefbarview]-(-\(pictureHeight))-[feeddateview]",
            options: [],
            metrics: nil, views: ["ava":avaImg, "pic":picImg, "feeddefbarview":feedDefBarView, "feeddateview":feedDateDefView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[username(30)]-10-[pic(\(pictureHeight))]-(-40)-[feeddefbarview]-(-\(pictureHeight))-[feeddateview]",
            options: [],
            metrics: nil, views: ["username":usernameBtn,"pic":picImg, "feeddefbarview":feedDefBarView, "feeddateview":feedDateDefView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[datelbl(30)]-10-[pic(\(pictureHeight))]-(-40)-[feeddefbarview]-0-[feedcommentview]-|",
            options: [],
            metrics: nil, views: ["datelbl":dateLbl,"pic":picImg, "feeddefbarview":feedDefBarView, "feedcommentview":feedCommentView]))

        self.feedDefBarView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[likebtn(30)]-5-|",
            options: [],
            metrics: nil, views: ["likebtn":likeBtn]))

        self.feedDefBarView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[likenr(30)]-5-|",
            options: [],
            metrics: nil, views: ["likenr":likeLbl]))
        
        self.feedDefBarView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[commentbtn(30)]-5-|",
            options: [],
            metrics: nil, views: ["commentbtn":commentBtn]))
        
        self.feedDefBarView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[commentnr(30)]-5-|",
            options: [],
            metrics: nil, views: ["commentnr":commentNrLbl]))

        self.feedDefBarView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-13-[rateview(15)]-12-|",
            options: [],
            metrics: nil, views: ["rateview":rateView]))

        self.feedDefBarView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[morebtn(30)]-5-|",
            options: [],
            metrics: nil, views: ["morebtn":moreBtn]))
        
        self.feedDateDefView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[fromlbl(15)]-5-[fromdate(15)]-5-[tolbl(15)]-5-[todate(15)]",
            options: [],
            metrics: nil, views: ["fromlbl":fromStrLbl, "fromdate":fromDateLbl, "tolbl":toStrLbl, "todate":toDateLbl]))

        self.feedCommentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[titlelbl]-5-|",
            options: [],
            metrics: nil, views: ["titlelbl":titleLbl]))
       
        // horizontal alignement
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[ava(30)]-10-[username]-10-[datelbl(30)]-10-|",
            options: [],
            metrics: nil, views: ["ava":avaImg, "username":usernameBtn, "datelbl":dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[pic(\(pictureWidth))]-0-|",
            options: [],
            metrics: nil, views: ["pic":picImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[feeddateview]-10-|",
            options: [],
            metrics: nil, views: ["feeddateview":feedDateDefView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[feeddefbarview]-0-|",
            options: [],
            metrics: nil, views: ["feeddefbarview":feedDefBarView]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[feedcommentview]-0-|",
            options: [],
            metrics: nil, views: ["feedcommentview":feedCommentView]))

        self.feedDefBarView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[likebtn(30)]-10-[likenr(30)]-10-[commentbtn(30)]-10-[commentnr(30)]-10-[rateview]-10-[morebtn(30)]-10-|",
            options: [],
            metrics: nil, views: ["likebtn":likeBtn, "likenr":likeLbl, "commentbtn":commentBtn, "commentnr":commentNrLbl, "rateview":rateView, "morebtn":moreBtn]))

        self.feedDateDefView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[fromlbl(70)]-10-|",
            options: [],
            metrics: nil, views: ["fromlbl":fromStrLbl]))
        
        self.feedDateDefView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[fromdate(70)]-10-|",
            options: [],
            metrics: nil, views: ["fromdate":fromDateLbl]))
        
        self.feedDateDefView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[todatelbl(70)]-10-|",
            options: [],
            metrics: nil, views: ["todatelbl":toStrLbl]))
        
        self.feedDateDefView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[todate(70)]-10-|",
            options: [],
            metrics: nil, views: ["todate":toDateLbl]))

        self.feedCommentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-5-[titlelbl]-5-|",
            options: [],
            metrics: nil, views: ["titlelbl":titleLbl]))
        
        // add additional cell properties
        self.backgroundColor = .white
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        // create hidden button over rateView
        rateView.backgroundColor = .clear
        rateView.starSize = 15
        
    }
    
    // clicked like button
    @IBAction func likeBtn_clicked(_ sender: AnyObject) {
        
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
        let zoomed = CGRect(x: 0, y: self.contentView.center.y - self.contentView.center.x, width: self.contentView.frame.size.width, height: self.contentView.frame.size.width)
        
        // frame of unzoomed (small) image
        //let unzoomed = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
        let unzoomed = CGRect(x: 10, y: 83, width: pictureWidth, height: pictureWidth)
        
        // id picture is unzoomed, zoom it
        if picImg.frame == unzoomed {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.picImg.frame = zoomed
                
                // hide objects from background
                self.contentView.backgroundColor = .black
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
            })
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.picImg.frame = unzoomed
                
                // unhide objects from background
                self.contentView.backgroundColor = .white
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
    
    func handleTap(_ sender: AnyObject) {
        print("hello world")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
