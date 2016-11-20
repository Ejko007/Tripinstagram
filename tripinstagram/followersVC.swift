//
//  followersVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

var showit = String()
var user = String()


class followersVC: UITableViewController {
    
    // Arrays to hold data received from server
    var usernameArray = [String]()
    var avaArray = [PFFile]()

    // Array showing who do we follow or who following us
    var followArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title at the top
        self.navigationItem.title = showit.uppercased()
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        // load followers if tapped on follower tab
        if showit == followers_str {      // "followers"
            loadFollowers()
        }
        
        // load followers if tapped on following tab
        if showit == followings_str {     // "followings"
            loadFollowings()
        }
    }

    // loadinf followers
    func loadFollowers() {
        
        // STEP 1. Find in FOLLOW class people following user
        // find followers of user
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("following", equalTo: user)
        followQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clean up
                self.followArray.removeAll(keepingCapacity: false)
                
                // STEP 2. Hold received data
                // find related objects
                for object in objects! {
                    self.followArray.append(object.value(forKey: "follower") as! String)
                }
                
                // STEP 3. Find in USER class data of users following "user"
                // find users following user
                let query = PFQuery(className: "_User")   /* it means for "_User" class */
                query.whereKey("username", containedIn: self.followArray)
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                    if error == nil {
                        
                        // clean up
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.avaArray.removeAll(keepingCapacity: false)
                        
                        // find related objects in User class of Parse
                        for object in objects! {
                            self.usernameArray.append(object.object(forKey: "username") as! String)
                            self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                            self.tableView.reloadData()
                        }
                    } else {
                        print (error!.localizedDescription)
                    }
                })
               
            } else {
                print (error!.localizedDescription)
            }
        })
    }
    
    // loading followings
    func loadFollowings() {
        
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: user)
        followQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clean up
                self.followArray.removeAll(keepingCapacity: false)
                
                // find related objects in "follow" class Parse
                for object in objects! {
                    self.followArray.append(object.value(forKey: "following") as! String)
                }
                
                // find users followed by user
                let query = PFQuery(className: "_User") // It means class "_User"
                query.whereKey("username", containedIn: self.followArray)
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                    if error == nil {
                        
                        // clean array
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.avaArray.removeAll(keepingCapacity: false)
                        
                        // find related objects in "User" class of Parse
                        for object in objects! {
                            self.usernameArray.append(object.object(forKey: "username") as! String)
                            self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                            self.tableView.reloadData()
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                    
                })
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    

    // cell number
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernameArray.count
    }
    
    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width / 4
    }

    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! followersCell
        
        // STEP 1. connect data from server to objects
        cell.usernameLbl.text = usernameArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackground(block: { (data:Data?, error:Error?) in
            if error == nil {
                cell.avaImg.image = UIImage(data:data!)
            } else {
                print(error!.localizedDescription)
            }
        })
  
        
        // STEP 2. show does user following or does not
        let query = PFQuery(className: "follow")
        query.whereKey("follower", equalTo: PFUser.current()!.username!)
        query.whereKey("following", equalTo: cell.usernameLbl.text!)
        query.countObjectsInBackground(block: { (count:Int32, error:Error?) in
            if error == nil {
                if count == 0 {
                    cell.followBtn.setTitle(follow_str.uppercased(), for: UIControlState.normal)
                    cell.followBtn.backgroundColor = .lightGray
                } else {
                    cell.followBtn.setTitle(following_str.uppercased(), for: UIControlState.normal)
                    cell.followBtn.backgroundColor = UIColor(red: 31 / 255, green: 143 / 255, blue: 0 / 255, alpha: 1)
                }
            }
        })
        
        // hide FOLLOW button for current user
        if cell.usernameLbl.text == PFUser.current()?.username {
            cell.followBtn.isHidden = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // recall cell to call futher cell's data
        let cell = tableView.cellForRow(at: indexPath) as! followersCell
        
        // if user tapped on himself, go home, else go guest
        if cell.usernameLbl.text! == PFUser.current()!.username! {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append(cell.usernameLbl.text!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
        
    }


    func back(sender: UITabBarItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
