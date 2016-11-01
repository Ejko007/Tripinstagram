//
//  hashtagsVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

var hashtag = [String]()

class hashtagsVC: UICollectionViewController {
    
    // UI Objects
    var refresher : UIRefreshControl!
    var page : Int = 24
    
    // arrays to hold data from the server
    var picArray = [PFFile]()
    var uuidArray = [String]()
    
    var filterArray = [String]()
    

    // Default function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // be able to pull down if even few posts
        self.collectionView?.alwaysBounceVertical = true
        
        // title at the top
        self.navigationItem.title = "#" + "\(hashtag.last!.uppercased())"
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        // pull to refresh
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refresher)

        // call function of loading hashtags
        loadHashtags()

    }
    
    // back function
    func back(sender: UIBarButtonItem) {
        
        // push back
        if ((self.navigationController?.popViewController(animated: true)) != nil) {
            return
        }
        
        // clean hashtag or deduct the last guest username from guestname Array
        if !hashtag.isEmpty {
            hashtag.removeLast()
        }
    }

    // refreshing function
    func refresh () {
        loadHashtags()
    }
    
    // load hashtag function
    func loadHashtags () {
        
        // STEP 1. Finf posts related to hashtags
        let hashtagQuery = PFQuery(className: "hashtags")
        hashtagQuery.whereKey("hashtag", equalTo: hashtag.last!)
        hashtagQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clean up
                self.filterArray.removeAll(keepingCapacity: false)
                
                // store related posts at filter array
                for object in objects! {
                    self.filterArray.append(object.value(forKey: "to") as! String)
                }
                
                // STEP 2. Find posts that have uuid appended to filterarray
                let query = PFQuery(className: "posts")
                query.whereKey("uuid", containedIn: self.filterArray)
                query.limit = self.page
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                    if error == nil {
                        
                        // clean up
                        self.picArray.removeAll(keepingCapacity: false)
                        self.uuidArray.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                        
                            // find related objects
                            self.picArray.append(object.value(forKey: "pic") as! PFFile)
                            self.uuidArray.append(object.object(forKey: "uuid") as! String)
                        }
                        
                        // reload
                        self.collectionView?.reloadData()
                        self.refresher.endRefreshing()
                        
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                })
            } else {
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    // scrolled down
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= scrollView.contentSize.height {
            loadMore()
        }
    }
    
    // pagination
    func loadMore() {
        
        // if posts on the server are more than shown
        if page <= uuidArray.count {
            
            // increase page size
            page += 15
            
            // STEP 1. Finf posts related to hashtags
            let hashtagQuery = PFQuery(className: "hashtags")
            hashtagQuery.whereKey("hashtag", equalTo: hashtag.last!)
            hashtagQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    // clean up
                    self.filterArray.removeAll(keepingCapacity: false)
                    
                    // store related posts at filter array
                    for object in objects! {
                        self.filterArray.append(object.value(forKey: "to") as! String)
                    }
                    
                    // STEP 2. Find posts that have uuid appended to filterarray
                    let query = PFQuery(className: "posts")
                    query.whereKey("uuid", containedIn: self.filterArray)
                    query.limit = self.page
                    query.addDescendingOrder("createdAt")
                    query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                        if error == nil {
                            
                            // clean up
                            self.picArray.removeAll(keepingCapacity: false)
                            self.uuidArray.removeAll(keepingCapacity: false)
                            
                            for object in objects! {
                                
                                // find related objects
                                self.picArray.append(object.value(forKey: "pic") as! PFFile)
                                self.uuidArray.append(object.object(forKey: "uuid") as! String)
                            }
                            
                            // reload
                            self.collectionView?.reloadData()
                            
                        } else {
                            print(error?.localizedDescription as Any)
                        }
                    })
                } else {
                    print(error?.localizedDescription as Any)
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
    
    // go post
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // send post uuid to "postuuid" variable
        postuuid.append(uuidArray[indexPath.row])
        
        // navigate to post view controller
        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
        
    }


}
