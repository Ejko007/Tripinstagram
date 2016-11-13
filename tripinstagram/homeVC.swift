//
//  homeVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class homeVC: UICollectionViewController {
    
    // refresher variable
    var refresher : UIRefreshControl!
    
    // size of page
    var page : Int = 12
    
    var uuidArray = [String]()
    var picArray = [PFFile]()
    
    var genderColor = UIColor()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // always vertical scroll
        self.collectionView?.alwaysBounceVertical = true
        
        
        // background color
        collectionView?.backgroundColor = .white
        
        // title at the top
        self.navigationItem.title = PFUser.current()?.username?.uppercased()
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(homeVC.refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        // receive notification from editVC
        NotificationCenter.default.addObserver(self, selector: #selector(homeVC.reload(notification:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
                
        // load posts func
        loadposts()
    }
    
    
    // reloading function after receive notification
    func reload (notification: NSNotification) {
        collectionView?.reloadData()
    }
    
    // refreshing function
    func refresh() {
        //collectionView?.reloadData()
        // refresher.endRefreshing()
        
        // reload posts
        loadposts()
        
        // stop refresher animating
        refresher.endRefreshing()

    }
    
    // load posts function
    func loadposts() {
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        query.limit = page
        query.findObjectsInBackground (block: { (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                
                // clean up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                // find objects related to our query request
                for object in objects! {
                    
                    // add found data to arrays
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFile)
                    
                }
            
                self.collectionView?.reloadData()
                
            } else {
                print (error!.localizedDescription)
            }
        })
    }
    
    // load more while scrolling down
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height) {
            loadMore()
        }
    }
    
    // pagination - or paging
    func loadMore () {
        
        if page <= picArray.count {
            
            // increase page size if there is moore objects
            page += 12
            
            // load more posts
            let query = PFQuery(className: "posts")
            query.whereKey("username", equalTo: PFUser.current()!.username!)
            query.limit = page
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    // clean up
                    self.uuidArray.removeAll(keepingCapacity: false)
                    self.picArray.removeAll(keepingCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.uuidArray.append(object.value(forKey: "uuid") as! String)
                        self.picArray.append(object.value(forKey: "pic") as! PFFile)
                    }
                    
                    self.collectionView?.reloadData()
                    
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    

    // cells number
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    // cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
        
        return size
    }
    
    // cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        
        // get picture from the picArray
        picArray[indexPath.row].getDataInBackground (block: { (data: Data?, error: Error?) -> Void in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        })
        return cell
    }

    // header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! headerView
        
        // STEP 1. Get user data
        header.fullnameLbl.text = (PFUser.current()?.object(forKey: "fullname") as? String)?.uppercased()
        header.webTxt.text = PFUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        header.bioLbl.text = PFUser.current()?.object(forKey: "bio") as? String
        header.bioLbl.sizeToFit()
        
        let gender = PFUser.current()?.object(forKey: "gender") as! String
        if gender == "male" {
            genderColor = .blue
        } else {
            genderColor = .red
        }
        
        let avaQuery = PFUser.current()?.object(forKey: "ava") as! PFFile
        avaQuery.getDataInBackground(block: { (data: Data?, error: Error?) in
            if error == nil {
                header.avaImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        })
        header.button.setTitle(update_profile_str, for: UIControlState.normal)
        
        // STEP 2. Count Statistics
        // count total posts
        let posts = PFQuery(className: "posts")
        let currentUser = PFUser.current()?.username
        posts.whereKey("username", equalTo: currentUser!)
        posts.countObjectsInBackground { (count:Int32, error:Error?)  in
            if error == nil {
                header.posts.text = "\(count)"
            } else {
                print(error!.localizedDescription)
            }
        }
        
        // count total followers
        let followers = PFQuery(className: "follow")
        followers.whereKey("following", equalTo: currentUser!)
        followers.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                header.followers.text = "\(count)"
            } else {
                print(error!.localizedDescription)
            }
       }
        
        // count total following people
        let followings = PFQuery(className: "follow")
        followings.whereKey("follower", equalTo: currentUser!)
        followings.countObjectsInBackground { (count:Int32, error:Error?) in
            if error == nil {
                header.followings.text = "\(count)"
            } else {
                print(error!.localizedDescription)
            }
       }
        
        // STEP 3. Implement tap gestures
        // tap posts
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(postsTap(_:)))
        
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        // tap followers
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followersTap(_:)))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        //tap followings
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(followingsTap(_:)))
        followingsTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followingsTap)
        
        return header
    }
    
    // tapped posts label
    func postsTap (_ sender: UITapGestureRecognizer) {
        if !picArray.isEmpty {
            
            let index = NSIndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    
    
    // tapped followers
    func followersTap (_ sender: UITapGestureRecognizer) {
        
        user = (PFUser.current()!.username)!
        
        showit = followers_str
        
        // make references to followersVC
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // present it
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    func followingsTap (_ sender: UITapGestureRecognizer) {
        
        user = (PFUser.current()!.username)!
        
        showit = followings_str
        
        // make references to followersVC
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // present it
        self.navigationController?.pushViewController(followings, animated: true)
    }
   
    // clicked log out
    @IBAction func logout(_ sender: AnyObject) {
        
        PFUser.logOutInBackground(block: { (error: Error?) in
            
            if error == nil {
                
                // remove loged in user from app memory
                UserDefaults.standard.removeObject(forKey: "username")
                UserDefaults.standard.synchronize()
                
                let signin = self.storyboard?.instantiateViewController(withIdentifier: "singInVC") as! singInVC
                
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = signin
                
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    // go post
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // send post uuid to "postuuid" variable
        postuuid.append(uuidArray[indexPath.row])
        
        // navigate to post view controller
        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
        
    }
    
}
