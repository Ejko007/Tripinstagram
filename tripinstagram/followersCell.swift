//
//  followersCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class followersCell: UITableViewCell {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    

    // default function
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignement
        let width = UIScreen.main.bounds.width
        
        avaImg.frame = CGRect(x: 10, y: 10, width: width / 5.3, height: width / 5.3)
        usernameLbl.frame = CGRect(x: avaImg.frame.size.width + 20, y: 28, width: width / 3.2, height: 30)
        followBtn.frame = CGRect(x: width - width / 3.5 - 10, y: 30, width: width / 3.5, height: 30)
        followBtn.layer.cornerRadius = followBtn.frame.size.width / 20
        
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // clicked FOLLOW / UNFOLLOW
    @IBAction func followBtn_click(_ sender: AnyObject) {
        
        let title = followBtn.title(for: .normal)
        
        // to follow
        if title == follow_str.uppercased() {    // "FOLLOW"
            let object = PFObject(className: "follow")
            object["follower"] = PFUser.current()?.username
            object["following"] = usernameLbl.text
            object.saveInBackground(block: { (success: Bool, error: Error?) in
                if success {
                    self.followBtn.setTitle(following_str.uppercased(), for: UIControlState.normal)
                    self.followBtn.backgroundColor = UIColor(red: 31 / 255, green: 143 / 255, blue: 0 / 255, alpha: 1)
                } else {
                    print(error?.localizedDescription as Any)
                }
            })

        // unfollow
        } else {
            
            let query = PFQuery(className: "follow")
            query.whereKey("follower", equalTo: PFUser.current()!.username!)
            query.whereKey("following", equalTo: usernameLbl.text!)
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteInBackground(block: { (success: Bool, error: Error?) in
                            if success {
                                self.followBtn.setTitle(follow_str.uppercased(), for: UIControlState.normal)
                                self.followBtn.backgroundColor = .lightGray
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
