//
//  headerView.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class headerView: UICollectionReusableView {
    
    let width = UIScreen.main.bounds.width
    
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var webTxt: UITextView!
    @IBOutlet weak var bioLbl: UILabel!
    
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var followersTitle: UILabel!
    @IBOutlet weak var followingsTitle: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    // Default action
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        avaImg.frame = CGRect(x: width / 16, y: width / 16, width: width / 4, height: width / 4)
        
        posts.frame = CGRect(x: width / 2.5, y: avaImg.frame.origin.y, width: 50, height: 30)
        followers.frame = CGRect(x: width / 1.7, y: avaImg.frame.origin.y, width: 50, height: 30)
        followings.frame = CGRect(x: width / 1.3, y: avaImg.frame.origin.y, width: 50, height: 30)
        
        postTitle.center = CGPoint(x: posts.center.x, y: posts.center.y + 20)
        followersTitle.center = CGPoint(x: followers.center.x, y: followers.center.y + 20)
        followingsTitle.center = CGPoint(x: followings.center.x, y: followings.center.y + 20)
        
        button.frame = CGRect(x: postTitle.frame.origin.x, y: postTitle.center.y + 20, width: width - postTitle.frame.origin.x - 10, height: 30)
        button.layer.cornerRadius = button.frame.size.width / 50
        
        fullnameLbl.frame = CGRect(x: avaImg.frame.origin.x, y: avaImg.frame.origin.y + avaImg.frame.size.height + 10, width: width - 30, height: 30)
        
        webTxt.frame = CGRect(x: avaImg.frame.origin.x - 5, y: fullnameLbl.frame.origin.y + 15, width: width - 30, height: 30)
        
        bioLbl.frame = CGRect(x: avaImg.frame.origin.x, y: webTxt.frame.origin.y + 30, width: width - 30, height: 30)
        
        // round ava with shadow
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        putShadowOnView(avaImg, shadowColor: .black, radius: avaImg.layer.cornerRadius, offset: CGSize(width: 10.0, height: 10.0), opacity: 0.9)
    }
    
    // coloured shadow around avatar image
    func putShadowOnView(_ viewToWorkUpon: UIImageView, shadowColor: UIColor, radius: CGFloat, offset: CGSize, opacity: Float) {
        
        var shadowFrame = CGRect.zero
        
        shadowFrame.size.width = 0.0
        shadowFrame.size.height = 0.0
        shadowFrame.origin.x = 0.0
        shadowFrame.origin.y = 0.0
        
        let shadow = UIImageView(frame: shadowFrame)
        
        shadow.isUserInteractionEnabled = false
        shadow.layer.shadowColor = shadowColor.cgColor
        shadow.layer.shadowOffset = offset
        shadow.layer.shadowRadius = radius
        shadow.layer.masksToBounds = false
        shadow.clipsToBounds = false
        shadow.layer.shadowOpacity = opacity
        
        viewToWorkUpon.superview?.insertSubview(shadow, belowSubview: viewToWorkUpon)
        shadow.addSubview(viewToWorkUpon)
        
    }
    

    // Clicked follow button from GuestVC
    @IBAction func followBtn_clicked(_ sender: AnyObject) {
        let title = button.title(for: .normal)
        
        // to follow
        if title == follow_str.uppercased() {     // "FOLLOW"
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = guestname.last
            object.saveInBackground(block: { (success: Bool, error: Error?) in
                if success {
                    self.button.setTitle(following_str.uppercased(), for: UIControlState.normal)
                    self.button.backgroundColor = UIColor(red: 31 / 255, green: 143 / 255, blue: 0 / 255, alpha: 1)
                    
                    // send follow notification
                    let newsObj = PFObject(className: "news")
                    newsObj["by"] = PFUser.current()?.username
                    newsObj["gender"] = PFUser.current()?.object(forKey: "gender") as! String
                    newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
                    newsObj["to"] = guestname.last!
                    newsObj["owner"] = ""
                    newsObj["uuid"] = ""
                    newsObj["type"] = "follow"
                    newsObj["checked"] = "no"
                    newsObj.saveEventually()

                } else {
                    print(error?.localizedDescription as Any)
                }
            })
            
            // unfollow
        } else {
            
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()?.username as Any)
            query.whereKey("following", equalTo: guestname.last!)
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteInBackground(block: { (success: Bool, error: Error?) in
                            if success {
                                self.button.setTitle(follow_str.uppercased(), for: UIControlState.normal)
                                self.button.backgroundColor = .lightGray
                                
                                // delete follow notification
                                let newsQuery = PFQuery(className: "news")
                                newsQuery.whereKey("by", equalTo: PFUser.current()!.username!)
                                newsQuery.whereKey("to", equalTo: guestname.last!)
                                newsQuery.whereKey("type", equalTo: "follow")
                                newsQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                                    if error == nil {
                                        for object in objects! {
                                            object.deleteEventually()
                                        }
                                    } else {
                                        print(error!.localizedDescription)
                                    }
                                })

                            } else {
                                print(error?.localizedDescription as Any)
                            }
                        })
                    }
                } else {
                    print (error?.localizedDescription as Any)
                }
            })
        }
    }
}
