//
//  feedVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class feedVC: UITableViewController {
    
    // UI objects
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    
    var refresher = UIRefreshControl()
    
    // Arrays to hold server data
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var dateArray = [NSDate?]()
    var picArray = [PFFile]()
    var titleArray = [String]()
    var uuidArray = [String]()
    var ratesArray = [Double]()
    
    var followArray = [String]()
    
    // page size
    var page : Int = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // title at top
        self.navigationItem.title = feed_str.uppercased()
        
        // automatic row height - dynamic cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 450
        
        // pull to refresh
        refresher.addTarget(self, action: #selector(loadPosts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        // receive notification from postCell if picture is liked to update tableView
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "liked"), object: nil)
        
        // indicator's X center (horizontally)
        indicator.center.x = tableView.center.x
        
        // receive notification from uploadVC
        NotificationCenter.default.addObserver(self, selector: #selector(uploaded(notification:)), name: NSNotification.Name(rawValue: "uploaded"), object: nil)
        
        // calling function to load posts
        loadPosts()
    
    }
    
    // uploading function with posts after receive notification
    func uploaded (notification: NSNotification) {
        loadPosts()
    }
    
    // refreshing function after like to update digit
    func refresh() {
        tableView.reloadData()
    }
        
    // load posts
    func loadPosts() {
        
        // STEP 1. Find posts related to people who we are following
        let followQuery = PFQuery(className: "follow")
        followQuery.whereKey("follower", equalTo: PFUser.current()!.username!)
        followQuery.findObjectsInBackground(block: {(objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clean up
                self.followArray.removeAll(keepingCapacity: false)
                
                // find related objects
                for object in objects! {
                    self.followArray.append(object.object(forKey: "following") as! String)
                }
                
                // append current user to see own posts in feed
                self.followArray.append(PFUser.current()!.username!)
                
                // STEP 2. Find posts made by by people appended to followArray
                let query = PFQuery(className: "posts")
                query.whereKey("username", containedIn: self.followArray)
                query.limit = self.page
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                    if error == nil {
                        
                        // clean up
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.avaArray.removeAll(keepingCapacity: false)
                        self.dateArray.removeAll(keepingCapacity: false)
                        self.picArray.removeAll(keepingCapacity: false)
                        self.titleArray.removeAll(keepingCapacity: false)
                        self.uuidArray.removeAll(keepingCapacity: false)
                        self.ratesArray.removeAll(keepingCapacity: false)
 
                        // find related objects
                        for object in objects! {
                            self.usernameArray.append(object.object(forKey: "username") as! String)
                            self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                            self.dateArray.append(object.createdAt as NSDate?)
                            self.picArray.append(object.object(forKey: "pic") as! PFFile)
                            self.titleArray.append(object.object(forKey: "title") as! String)
                            self.uuidArray.append(object.object(forKey: "uuid") as! String)
                            self.ratesArray.append(calculateRates(uuid: self.uuidArray.last!))
                        }
                        
                        // reload tableView and stop spinning of refresher
                        self.tableView.reloadData()
                        self.refresher.endRefreshing()
                        
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            } else {
                print(error!.localizedDescription)
            }
        })
    }

    // scrolled down
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
           loadMore()
        }
    }
    
    // pagination
    func loadMore () {
        
        // if posts on the server are more than shown
        if page <= uuidArray.count {
            
            // start animating indicator
            indicator.startAnimating()
            
            // increase page to load + 10 posts
            page += 10
            
            // STEP 1. Find posts related to people who we are following
            let followQuery = PFQuery(className: "follow")
            followQuery.whereKey("follower", equalTo: PFUser.current()!.username!)
            followQuery.findObjectsInBackground(block: {(objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    // clean up
                    self.followArray.removeAll(keepingCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.followArray.append(object.object(forKey: "following") as! String)
                    }
                    
                    // append current user to see own posts in feed
                    self.followArray.append(PFUser.current()!.username!)
                    
                    // STEP 2. Find posts made by by people appended to followArray
                    let query = PFQuery(className: "posts")
                    query.whereKey("username", containedIn: self.followArray)
                    query.limit = self.page
                    query.addDescendingOrder("createdAt")
                    query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                        if error == nil {
                            
                            // clean up
                            self.usernameArray.removeAll(keepingCapacity: false)
                            self.avaArray.removeAll(keepingCapacity: false)
                            self.dateArray.removeAll(keepingCapacity: false)
                            self.picArray.removeAll(keepingCapacity: false)
                            self.titleArray.removeAll(keepingCapacity: false)
                            self.uuidArray.removeAll(keepingCapacity: false)
                            
                            // find related objects
                            for object in objects! {
                                self.usernameArray.append(object.object(forKey: "username") as! String)
                                self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                                self.dateArray.append(object.createdAt as NSDate?)
                                self.picArray.append(object.object(forKey: "pic") as! PFFile)
                                self.titleArray.append(object.object(forKey: "title") as! String)
                                self.uuidArray.append(object.object(forKey: "uuid") as! String)
                            }
                            
                            // reload tableView and stop animation
                            self.tableView.reloadData()
                            self.indicator.stopAnimating()
                            
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
        
    }

    // cell numb
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return uuidArray.count
    }
    
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! postCell
        
        // connect objects with our information from array
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: UIControlState.normal)
        cell.usernameBtn.sizeToFit()
        cell.uuidLbl.text = uuidArray[indexPath.row]
        cell.titleLbl.text = titleArray[indexPath.row]
        cell.titleLbl.sizeToFit()
        
        // place profile picture
        avaArray[indexPath.row].getDataInBackground(block: { (data: Data?, error: Error?) in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        })
        
        // place post picture
        picArray[indexPath.row].getDataInBackground(block: { (data: Data?, error: Error?) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print (error!.localizedDescription)
            }
        })
        
        // calcula post date
        let from = dateArray[indexPath.row]
        let now = NSDate()
        // let components : NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = Calendar.current.dateComponents([.second, .minute, .hour, .day, .weekOfMonth], from: from! as Date, to: now as Date)
        
        // logic what  to show
        if difference.second! <= 0 {
            cell.dateLbl.text = now_str.lowercased() + "."
        }
        
        if difference.second! > 0 && difference.minute! == 0 {
            cell.dateLbl.text = "\(difference.second!)" + seconds_abbrav_str.lowercased() + "."
        }
        
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLbl.text = "\(difference.minute!)" + minutes_abbrav_str.lowercased() + "."
            
        }
        
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLbl.text = "\(difference.hour!)" + hours_abbrav_str.lowercased() + "."
        }
        
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLbl.text = "\(difference.day!)" + days_abbrav_str.lowercased() + "."
        }
        
        if difference.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth!)" + weeks_abbrav_str.lowercased() + "."
        }
        
        // manipulating like button on did user like or not
        let didLike = PFQuery(className: "likes")
        didLike.whereKey("by", equalTo: PFUser.current()!.username!)
        didLike.whereKey("to", equalTo: cell.uuidLbl.text!)
        didLike.countObjectsInBackground (block: { (count: Int32, error: Error?) in
            if count == 0 {
                cell.likeBtn.setTitle("unlike", for: .normal)
                cell.likeBtn.setBackgroundImage(UIImage(named: "unlike.png"), for: UIControlState.normal)
            } else {
                cell.likeBtn.setTitle("like", for: .normal)
                cell.likeBtn.setBackgroundImage(UIImage(named: "like.png"), for: UIControlState.normal)
            }
        })
        
        // count total likes of showing post
        let countLikes = PFQuery(className: "likes")
        countLikes.whereKey("to", equalTo: cell.uuidLbl.text!)
        countLikes.countObjectsInBackground(block:  { (count: Int32, error: Error?) in
            cell.likeLbl.text = "\(count)"
        })
        
        // calculate total rates of showing post
        cell.rateView.rating = calculateRates(uuid: cell.uuidLbl.text!)
                
        // assign index
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        cell.commentBtn.layer.setValue(indexPath, forKey: "index")
        cell.moreBtn.layer.setValue(indexPath, forKey: "index")
        
        // @mension is tapped
        cell.titleLbl.userHandleLinkTapHandler = { label, handle, rang in
            var mention = handle
            mention = String(mention.characters.dropFirst())
            
            // if tapped on @current user go home, else go guest
            if mention.lowercased() == PFUser.current()?.username {
                let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
                self.navigationController?.pushViewController(home, animated: true)
            } else {
                guestname.append(mention.lowercased())
                let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
                self.navigationController?.pushViewController(guest, animated: true)
            }
        }
        
        // hashtag is tapped
        cell.titleLbl.hashtagLinkTapHandler = { label, handle, range in
            var mention = handle
            mention = String(mention.characters.dropFirst())
            hashtag.append(mention.lowercased())
            let hashvc = self.storyboard?.instantiateViewController(withIdentifier: "hashtagsVC") as! hashtagsVC
            self.navigationController?.pushViewController(hashvc, animated: true)
        }
        return cell
    }

    // clicked username button
    @IBAction func usernameBtn_click(_ sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.value(forKey: "index") as! NSIndexPath
        
        // call cell to call further data
        let cell = tableView.cellForRow(at: i as IndexPath) as! postCell
        
        // if user tapped on himself go home - otherwise go guest
        if cell.usernameBtn.titleLabel?.text?.uppercased() == PFUser.current()?.username?.uppercased() {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append((cell.usernameBtn.titleLabel!.text)!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
        
    }
    
    // clicked comment button
    @IBAction func commentBtn_click(_ sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.value(forKey: "index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i as IndexPath) as! postCell
        
        // send related data to global variables
        commentuuid.append(cell.uuidLbl.text!)
        commentowner.append(cell.usernameBtn.titleLabel!.text!)
        
        // go to comments. present its VC
        let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
        self.navigationController?.pushViewController(comment, animated: true)
    }
    
    // clicked more button
    @IBAction func moreBtn_click(_ sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.value(forKey: "index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i as IndexPath) as! postCell
        
        // DELETE ACTION
        let del = UIAlertAction(title: "Smazat", style: .default, handler: { (UIAlertAction) in
            
            // STEP 1. Delete row from tableView
            self.usernameArray.remove(at: i.row)
            self.avaArray.remove(at: i.row)
            self.dateArray.remove(at: i.row)
            self.picArray.remove(at: i.row)
            self.titleArray.remove(at: i.row)
            self.uuidArray.remove(at: i.row)
            
            // STEP 2. Delete post from the server
            let postQuery = PFQuery(className: "posts")
            postQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
            postQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteInBackground(block: { (success: Bool, error: Error?) in
                            if success {
                                
                                // send notification to rootViewController to update shown posts
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
                                
                                // push back
                                _ = self.navigationController?.popViewController(animated: true)
                            } else {
                                print(error?.localizedDescription as Any)
                            }
                        })
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
            
            // STEP 3. Delete likes of post from the server
            let likeQuery = PFQuery(className: "likes")
            likeQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            likeQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteEventually()
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
            
            // STEP 4. Delete comments of post from the server
            let commentQuery = PFQuery(className: "comments")
            commentQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            commentQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteEventually()
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
            
            // STEP 5. Delete #hashtags of post from the server
            let hashtagQuery = PFQuery(className: "hashtags")
            hashtagQuery.whereKey("to", equalTo: cell.uuidLbl.text!)
            hashtagQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteEventually()
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
        })
        
        // COMPLAIN ACTION
        let compl = UIAlertAction(title: "Nahlásit", style: .default, handler: { (UIAlertAction) in
            
            // send complain to server
            let complainObj = PFObject(className: "complain")
            complainObj["by"] = PFUser.current()?.username
            complainObj["to"] = cell.uuidLbl.text!
            complainObj["owner"] = cell.usernameBtn.titleLabel?.text!
            complainObj.saveInBackground(block: { (success:Bool, error:Error?) in
                if error == nil {
                    if success {
                        self.alert(title: "Complain has been made successfully.", message: "Thank you! We will consider your complain.")
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
            })
            
        })
        
        // CANCEL ACTION
        let cancel = UIAlertAction (title: "Zrušit", style: .cancel, handler: nil)
        
        // create menu controller
        let menu = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        // if post belongs to user, he can delete post, else he can't
        if cell .usernameBtn.titleLabel?.text == PFUser.current()?.username {
            menu.addAction(del)
            menu.addAction(cancel)
        } else {
            menu.addAction(compl)
            menu.addAction(cancel)
        }
        
        // show menu
        self.present(menu, animated: true, completion: nil)
        
    }
    
    // alert action
    func alert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
 
}
