//
//  guestVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

var guestname = [String]()

class guestVC: UICollectionViewController {

    // UI objects
    var refresher = UIRefreshControl()
    
    var shadowColor = UIColor()
        
    var page : Int = 12
    
    // to hold data from server
    var uuidArray = [String]()
    var picArray = [PFFile]()
    
    // default func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // allow vertical scroll
        self.collectionView?.alwaysBounceVertical = true
        
        // background color
        self.collectionView?.backgroundColor = .white
        
        // top title
        self.navigationItem.title = guestname.last?.uppercased()
        
        // new back button
        self.navigationItem.hidesBackButton = true
        //let backBtn = UIBarButtonItem(title: "zpět", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(_:)))
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refreshing), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)
        
        // call load posts func
        loadPosts()
    }
    
    func back(sender: UIBarButtonItem) {
    
        // push back
        if ((self.navigationController?.popViewController(animated: true)) != nil) {
           return
        }
        
        
        // clean guest username or deduct the last guest username from guestname Array
        if !guestname.isEmpty {
            guestname.removeLast()
        }
    }
    
    // refresh func
    func refreshing() {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }

    // loading posts
    func loadPosts() {
        
        //load posts
        let query = PFQuery(className: "posts")
        query.whereKey("username", equalTo: guestname.last!)
        query.limit = page               //  ??????????????????????????????????????????
        query.findObjectsInBackground (block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clean up
                self.uuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                // find related objects
                for object in objects! {
                    
                    // hold found information in arrays
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.picArray.append(object.value(forKey: "pic") as! PFFile)
                }
                self.collectionView?.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    // load more while scrolling down
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height) {
            self.loadMore()
        }
    }
    
    // pagination - or paging
    func loadMore () {
        
        if page <= picArray.count {
            
            // increase page size if there is moore objects
            page += 12
            
            // load more posts
            let query = PFQuery(className: "posts")
            query.whereKey("username", equalTo: guestname.last!)
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
                    print(error?.localizedDescription as Any)
                }
            })
        }
    }


    // cell numb
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
        
        return size
    }
    
    // cell config
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! pictureCell
        
        // connect data from arrayto picImg object from picturecell class
        picArray[indexPath.row].getDataInBackground (block: { (data:Data?, error: Error?) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription as Any)
            }
        })
        return cell
    }
    
    // header config
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // define header
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! headerView
        
        // STEP 1. Load data of guest
        let infoQuery = PFQuery(className: "_User")  // It means "_User" class
        infoQuery.whereKey("username", equalTo: guestname.last!)
        infoQuery.findObjectsInBackground (block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // show wrong user name
                if objects!.isEmpty {
                    // call alert
                    let alert = UIAlertController(title: "\(guestname.last!.uppercased())", message: "nemá v aplikaci vytvořen účet.", preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                
                // find related to user information
                for object in objects! {
                    header.fullnameLbl.text = (object.object(forKey: "fullname") as? String)?.uppercased()
                    header.bioLbl.text = object.object(forKey: "bio") as? String
                    header.bioLbl.sizeToFit()
                    header.webTxt.text = object.object(forKey: "web") as? String
                    header.webTxt.sizeToFit()
                    let avaFile: PFFile = (object.object(forKey: "ava") as? PFFile)!
                    avaFile.getDataInBackground(block: { (data:Data?, error:Error?) in
                        header.avaImg.image = UIImage(data: data!)
                    })
                }
            } else {
                print(error?.localizedDescription as Any)
            }
        })
        
        // STEP 2. Show does current user follow guest or does not
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.current()!.username!)
        followQuery.whereKey("following", equalTo: guestname.last!)
        followQuery.countObjectsInBackground (block: { (count:Int32, error:Error?) in
            if error == nil {
                if count == 0 {
                    header.button.setTitle(follow_str.uppercased(), for: .normal)
                    header.button.backgroundColor = .lightGray
                } else {
                    header.button.setTitle(following_str.uppercased(), for: .normal)
                    header.button.backgroundColor = UIColor(red: 31 / 255, green: 143 / 255, blue: 0 / 255, alpha: 1)
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        
        // STEP 3. Count statistics
        let posts = PFQuery(className: "posts")
        posts.whereKey("username", equalTo: guestname.last!)
        posts.countObjectsInBackground(block: { (count:Int32, error:Error?) in
            if error == nil {
                header.posts.text = "\(count)"
            } else {
                print(error!.localizedDescription)
            }
        })
        
        // count followers
        let followers = PFQuery(className: "posts")
        followers.whereKey("following", equalTo: guestname.last!)
        followers.countObjectsInBackground(block: { (count:Int32, error:Error?) in
            if error == nil {
                header.followers.text = "\(count)"
            } else {
                print(error?.localizedDescription as Any)
            }
        })
        
        // count followings
        let followings = PFQuery(className: "follow")
        followings.whereKey("follower", equalTo: guestname.last!)
        followings.countObjectsInBackground(block: { (count:Int32, error:Error?) in
            if error == nil {
                header.followings.text = "\(count)"
            } else {
                print(error?.localizedDescription as Any)
            }
        })
        
        // STEP 4. Implement tap gestures
        // tap to posts label
        let postsTap = UITapGestureRecognizer(target: self, action: #selector(postTap))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        // tap to followers label
        let followersTap = UITapGestureRecognizer(target: self, action: #selector(followerTap))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        // tap to followings label
        let followingsTap = UITapGestureRecognizer(target: self, action: #selector(followingTap))
        followingsTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followingsTap)
        
        return header
    }
    
    // tapped posts label
    func postTap() {
        if !picArray.isEmpty {
            let index = IndexPath(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index as IndexPath, at: UICollectionViewScrollPosition.top, animated: true)
        }
    }
    
    // tapped followers label
    func followerTap() {
        user = guestname.last!
        showit = followers_str
        
        // define followersVC
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // navigate to it
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    // tapped following label
    func followingTap() {
        
        user = guestname.last!
        showit = followings_str
        
        // define followingsVC
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVC
        
        // navigate to it
        self.navigationController?.pushViewController(followings, animated: true)
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

