//
//  feedVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog

class feedVC: UITableViewController {
    
    // UI objects
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    
    var refresher = UIRefreshControl()
    
    // Arrays to hold server data
    var usernameArray = [String]()
    var genderArray = [String]()
    var avaArray = [PFFile]()
    var dateArray = [Date?]()
    var picArray = [PFFile]()
    var titleArray = [String]()
    var tripNameArray = [String]()
    var uuidArray = [String]()
    var ratesArray = [Double]()
    var publishedArray = [Bool]()
    var personsNrArray = [Int]()
    var totalDistanceArray = [Double]()
    var tripFromArray = [Date?]()
    var tripToArray = [Date?]()
    var levelArray = [Int]()
    
    var followArray = [String]()
    
    // page size
    var page : Int = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup cell height dynamicly
        self.tableView.estimatedRowHeight = UIScreen.main.bounds.width
        self.tableView.rowHeight = UITableViewAutomaticDimension

        // title at top
        self.navigationItem.title = feeds_str.uppercased()
                
        // pull to refresh
        refresher.addTarget(self, action: #selector(feedVC.loadPosts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
        
        // receive notification from postsCell if picture is liked, to update tableView
        NotificationCenter.default.addObserver(self, selector: #selector(feedVC.refresh), name: NSNotification.Name(rawValue: "liked"), object: nil)
       
        // indicator's X center (horizontally)
        indicator.center.x = tableView.center.x

        // receive notification from uploadVC
        NotificationCenter.default.addObserver(self, selector: #selector(feedVC.uploaded), name: NSNotification.Name(rawValue: "uploaded"), object: nil)
        
        // calling function to load posts
        loadPosts()
        
    
    }
    
    // uploading function with posts after receive notification
    func uploaded () {    // (notification: NSNotification)
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
                
                // STEP 2. Find posts made by people appended to followArray
                let query = PFQuery(className: "posts")
                query.whereKey("username", containedIn: self.followArray)
                query.whereKey("isPublished", equalTo: true)
                query.limit = self.page
                query.addDescendingOrder("createdAt")
                query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                    if error == nil {
                        
                        // clean up
                        self.usernameArray.removeAll(keepingCapacity: false)
                        self.genderArray.removeAll(keepingCapacity: false)
                        self.avaArray.removeAll(keepingCapacity: false)
                        self.dateArray.removeAll(keepingCapacity: false)
                        self.picArray.removeAll(keepingCapacity: false)
                        self.titleArray.removeAll(keepingCapacity: false)
                        self.tripNameArray.removeAll(keepingCapacity: false)
                        self.uuidArray.removeAll(keepingCapacity: false)
                        self.ratesArray.removeAll(keepingCapacity: false)
                        self.publishedArray.removeAll(keepingCapacity: false)
                        self.personsNrArray.removeAll(keepingCapacity: false)
                        self.totalDistanceArray.removeAll(keepingCapacity: false)
                        self.tripFromArray.removeAll(keepingCapacity: false)
                        self.tripToArray.removeAll(keepingCapacity: false)
                        self.levelArray.removeAll(keepingCapacity: false)
                        
 
                        // find related objects
                        for object in objects! {
                            self.usernameArray.append(object.object(forKey: "username") as! String)
                            self.genderArray.append(object.object(forKey: "gender") as! String)
                            self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                            self.dateArray.append(object.createdAt as Date?)
                            self.picArray.append(object.object(forKey: "pic") as! PFFile)
                            self.titleArray.append(object.object(forKey: "title") as! String)
                            self.tripNameArray.append(object.object(forKey: "tripName") as! String)
                            self.uuidArray.append(object.object(forKey: "uuid") as! String)
                            self.publishedArray.append(object.value(forKey: "isPublished") as! Bool)
                            self.personsNrArray.append(object.value(forKey: "personsNr") as! Int)
                            self.totalDistanceArray.append(object.value(forKey: "totalDistance") as! Double)
                            self.tripFromArray.append(object.value(forKey: "tripFrom") as! Date?)
                            self.tripToArray.append(object.value(forKey: "tripTo") as! Date?)
                            self.levelArray.append(object.value(forKey: "level") as! Int)
                           
                            
                            // calculate related rates values
                            var sumaRates: Double = 0.0
                            self.ratesArray.append(sumaRates)
                            let countRates = PFQuery(className: "rates")
                            countRates.whereKey("uuid", equalTo: object.value(forKey: "uuid") as! String)
                            countRates.findObjectsInBackground(block: { (ratesObjects: [PFObject]?, ratesError: Error?) in
                                
                                var i: Int = 1
                                if ratesError == nil {
                                    
                                    // calculate summary rates
                                    for ratesObject in ratesObjects! {
                                        sumaRates = sumaRates + (ratesObject.value(forKey: "rating") as! Double)
                                        i += 1
                                    }
                                    
                                    // add rates value to array
                                    if i > 1 {
                                        sumaRates = sumaRates / Double((i - 1))
                                    }
                                    
                                } else {
                                    print(ratesError!.localizedDescription)
                                }
                                self.ratesArray.removeLast()
                                self.ratesArray.append(sumaRates)
                            })
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
                    query.whereKey("isPublished", equalTo: true)
                    query.limit = self.page
                    query.addDescendingOrder("createdAt")
                    query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                        if error == nil {
                            
                            // clean up
                            self.usernameArray.removeAll(keepingCapacity: false)
                            self.genderArray.removeAll(keepingCapacity: false)
                            self.avaArray.removeAll(keepingCapacity: false)
                            self.dateArray.removeAll(keepingCapacity: false)
                            self.picArray.removeAll(keepingCapacity: false)
                            self.titleArray.removeAll(keepingCapacity: false)
                            self.tripNameArray.removeAll(keepingCapacity: false)
                            self.uuidArray.removeAll(keepingCapacity: false)
                            self.ratesArray.removeAll(keepingCapacity: false)
                            self.personsNrArray.removeAll(keepingCapacity: false)
                            self.totalDistanceArray.removeAll(keepingCapacity: false)
                            self.tripFromArray.removeAll(keepingCapacity: false)
                            self.tripToArray.removeAll(keepingCapacity: false)
                            self.levelArray.removeAll(keepingCapacity: false)
                            
                            // find related objects
                            for object in objects! {
                                self.usernameArray.append(object.object(forKey: "username") as! String)
                                self.genderArray.append(object.object(forKey: "gender") as! String)
                                self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                                self.dateArray.append(object.createdAt as Date?)
                                self.picArray.append(object.object(forKey: "pic") as! PFFile)
                                self.titleArray.append(object.object(forKey: "title") as! String)
                                self.tripNameArray.append(object.object(forKey: "tripName") as! String)
                                self.uuidArray.append(object.object(forKey: "uuid") as! String)
                                self.personsNrArray.append(object.object(forKey: "personsNr") as! Int)
                                self.totalDistanceArray.append(object.object(forKey: "totalDistance") as! Double)
                                self.tripFromArray.append(object.value(forKey: "tripFrom") as! Date?)
                                self.tripToArray.append(object.value(forKey: "tripTo") as! Date?)
                                self.levelArray.append(object.object(forKey: "level") as! Int)
                                
                                // calculate total rates of showing post
                                var sumaRates: Double = 0.0
                                self.ratesArray.append(sumaRates)
                                let countRates = PFQuery(className: "rates")
                                countRates.whereKey("uuid", equalTo: object.object(forKey: "uuid") as! String)
                                countRates.findObjectsInBackground(block: { (ratesObjects: [PFObject]?, ratesError: Error?) in
                                    
                                    var i: Int = 1
                                    if ratesError == nil {
                                        
                                        // calculate summary rates
                                        for ratesObject in ratesObjects! {
                                            sumaRates = sumaRates + (ratesObject.value(forKey: "rating") as! Double)
                                            i += 1
                                        }
                                        
                                        // add rates value to array
                                        if i > 1 {
                                            sumaRates = sumaRates / Double((i - 1))
                                        }
                                        
                                    } else {
                                        print(ratesError!.localizedDescription)
                                    }
                                    self.ratesArray.removeLast()
                                    self.ratesArray.append(sumaRates)
                                })
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
    
    // select cell in table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // send post uuid to "postuuid" variable
        postuuid.append(uuidArray[indexPath.row])
        
        // navigate to post view controller
        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
    }
    
    // cell numb
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return uuidArray.count
    }
    
    // fading and animation effects
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // define initial state (before the animation)
        cell.alpha = 0
        let rotationAngleInRadians = 90.0 * CGFloat(M_PI/180.0)
        let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1)
        //let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform = rotationTransform
        
        // define the final state (after the animation)
        UIView.animate(withDuration: 1.0, animations: {cell.alpha = 1})
        UIView.animate(withDuration: 1.0, animations: {cell.layer.transform = CATransform3DIdentity})
    }
        
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! postCell
        
        // connect objects with our information from array
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: UIControlState.normal)
        cell.usernameBtn.sizeToFit()
        if genderArray[indexPath.row] == "male" {
            cell.usernameBtn.tintColor = .blue
        } else {
            cell.usernameBtn.tintColor = .red
        }
        cell.uuidLbl.text = uuidArray[indexPath.row]
        cell.titleLbl.text = titleArray[indexPath.row]
        cell.titleLbl.sizeToFit()
        cell.tripNameLbl.text = tripNameArray[indexPath.row]
        cell.nrPersonsLbl.text = "\(personsNrArray[indexPath.row])"
        cell.totalDistanceLbl.text = String(format: "%.2f", totalDistanceArray[indexPath.row])
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyy"
        cell.fromDateLbl.text = dateformatter.string(from: tripFromArray[indexPath.row]!)
        cell.toDateLbl.text = dateformatter.string(from: tripToArray[indexPath.row]!)
        cell.levelLbl.text = "\(levelArray[indexPath.row])"
        
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
            
            if error == nil {
                cell.likeLbl.text = "\(count)"
            } else {
                print(error!.localizedDescription)
            }
        })
        
        // count total comments of showing post
        let countComments = PFQuery(className: "comments")
        countComments.whereKey("to", equalTo: cell.uuidLbl.text!)
        countComments.countObjectsInBackground(block:  { (count: Int32, error: Error?) in
            
            if error == nil {
                cell.commentNrLbl.text = "\(count)"
            } else {
                print(error!.localizedDescription)
            }
        })
        
        // calculate total spents of showing post
        var sumaSpents: Double = 0.0
        let countSpents = PFQuery(className: "tripspents")
        countSpents.whereKey("uuid", equalTo: cell.uuidLbl.text!)
        countSpents.findObjectsInBackground(block: { (spentsObjects: [PFObject]?, spentsError: Error?) in
            
            if spentsError == nil {
                
                // calculate summary rates
                for spentsObject in spentsObjects! {
                    sumaSpents = sumaSpents + (spentsObject.value(forKey: "spentAmount") as! Double)
                }
            } else {
                print(spentsError!.localizedDescription)
            }
            cell.totalSpentsLbl.text = String(format: "%.2f", sumaSpents)
        })
       
        // calculate total rates of showing post
        cell.rateView.updateOnTouch = false
        var sumaRates: Double = 0.0
        cell.rateView.rating = sumaRates
        let countRates = PFQuery(className: "rates")
        countRates.whereKey("uuid", equalTo: cell.uuidLbl.text!)
        countRates.findObjectsInBackground(block: { (ratesObjects: [PFObject]?, ratesError: Error?) in
            
            var i: Int = 1
            if ratesError == nil {
                
                // calculate summary rates
                for ratesObject in ratesObjects! {
                    sumaRates = sumaRates + (ratesObject.value(forKey: "rating") as! Double)
                    i += 1
                }
                
                // add rates value to array
                if i > 1 {
                    sumaRates = sumaRates / Double((i - 1))
                }
                
            } else {
                print(ratesError!.localizedDescription)
            }
            cell.rateView.rating = sumaRates
        })
        
        // assign index
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        cell.commentBtn.layer.setValue(indexPath, forKey: "index")
        cell.moreBtn.layer.setValue(indexPath, forKey: "index")
        //cell.rateBtn.layer.setValue(indexPath, forKey: "index")
        
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
    
    // clicked rate button
    @IBAction func rateBtn_click(_ sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.value(forKey: "index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i as IndexPath) as! postCell
        
        // send related data to global variables
        rateuuid.append(cell.uuidLbl.text!)
        rateowner.append(cell.usernameBtn.titleLabel!.text!)
        
        // count rates first
        let countQuery = PFQuery(className: "rates")
        countQuery.whereKey("uuid", equalTo: rateuuid.last!)
        countQuery.countObjectsInBackground (block: { (count: Int32, error: Error?) in
            if error == nil {
                
               if (count == 0) {
                    // no rates and curent user - show dialogbox
                    if PFUser.current()!.username! == cell.usernameBtn.titleLabel!.text! {
                        let okbtn = DefaultButton(title: ok_str, action: nil)
                        let complMenu = PopupDialog(title: rates_str, message: no_rates_str)
                        complMenu.addButtons([okbtn])
                        self.present(complMenu, animated: true, completion: nil)
                    } else {
                    // no rates but not curent user - create new rate option
                        let rate = self.storyboard?.instantiateViewController(withIdentifier: "rateVC") as! rateVC
                        self.navigationController?.pushViewController(rate, animated: true)
                    }
                } else {
                // find rate of current user
                let query = PFQuery(className: "rates")
                query.whereKey("username", equalTo: PFUser.current()!.username!)
                query.whereKey("uuid", equalTo: cell.uuidLbl.text!)
                query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    // not found
                    if objects!.isEmpty {
                        // go to rates. present its VC
                        let rate = self.storyboard?.instantiateViewController(withIdentifier: "rateVC") as! rateVC
                        self.navigationController?.pushViewController(rate, animated: true)
                        
                    } else {
                        
                        var objectID = String()
                        for objectIDs in objects! {
                            objectID = objectIDs.objectId!
                        }
                        
                        // Create a custom view controller
                        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
                        // Create the dialog
                        let menuDialog = PopupDialog(viewController: ratingVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
                        // Create first button
                        let buttonOne = CancelButton(title: cancel_button_str) {
                        }
                        // Create second button
                        let buttonTwo = DefaultButton(title: rate_it_str) {
                        
                            // save updated rating
                            // find rate of current user
                            let idquery = PFQuery(className: "rates")
                            idquery.whereKey("username", equalTo: PFUser.current()!.username!)
                            idquery.whereKey("uuid", equalTo: rateuuid[i.row])
                            idquery.getObjectInBackground(withId: objectID, block: { (object:PFObject?, error:Error?) in
                                if error == nil {
                                    if let updatedObject = object {
                                        updatedObject["rating"] = ratingVC.cosmosStarRating.rating
                                        updatedObject["ratingtxt"] = ratingVC.commentTextField.text
                                        updatedObject.saveInBackground()
                                    }
                                } else {
                                    print(error!.localizedDescription)
                                }
                            })
                            print("You rated \(ratingVC.cosmosStarRating.rating) stars")
                            
                            // send notification to rootViewController to update shown posts
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
                        }
                    
                        for object in objects! {
                            ratingVC.commentTextField?.text = (object.object(forKey: "ratingtxt") as! String)
                            ratingVC.cosmosStarRating?.rating = (object.object(forKey: "rating") as! Double)
                        }
                        
                        // Add buttons to dialog
                        menuDialog.addButtons([buttonOne, buttonTwo])
                        
                        // Present dialog
                        self.present(menuDialog, animated: true, completion: nil)
                   }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
            } else {
                print(error!.localizedDescription)
            }
        })
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
        
        var alertMsg : String
        
        // call index of button
        let i = sender.layer.value(forKey: "index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i as IndexPath) as! postCell
        
        // DELETE ACTION
        let del = DefaultButton(title: delete_str) {
            
            // STEP 1. Delete row from tableView
            self.usernameArray.remove(at: i.row)
            self.genderArray.remove(at: i.row)
            self.avaArray.remove(at: i.row)
            self.dateArray.remove(at: i.row)
            self.picArray.remove(at: i.row)
            self.titleArray.remove(at: i.row)
            self.tripNameArray.remove(at: i.row)
            self.ratesArray.remove(at: i.row)
            self.uuidArray.remove(at: i.row)
            self.publishedArray.remove(at: i.row)
            self.personsNrArray.remove(at: i.row)
            self.totalDistanceArray.remove(at: i.row)
            self.tripFromArray.remove(at: i.row)
            self.tripToArray.remove(at: i.row)
            self.levelArray.remove(at: i.row)
            
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
                                print(error!.localizedDescription)
                            }
                        })
                    }
                } else {
                    print(error!.localizedDescription)
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
                    print(error!.localizedDescription)
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
                    print(error!.localizedDescription)
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
                    print(error!.localizedDescription)
                }
            })
            
            // STEP 6. Delete rates of post from the server
            let rateQuery = PFQuery(className: "rates")
            rateQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
            rateQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    for object in objects! {
                        object.deleteEventually()
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
            
            // STEP 7. Delete spents of post from the server
            let spentQuery = PFQuery(className: "tripspents")
            spentQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
            spentQuery.findObjectsInBackground(block: { (spentsobjects: [PFObject]?, spentserror: Error?) in
                if spentserror == nil {
                    
                    for spentobject in spentsobjects! {
                        spentobject.deleteEventually()
                    }
                } else {
                    print(spentserror!.localizedDescription)
                }
            })
        }
        
        // COMPLAIN ACTION
         let compl = DefaultButton(title: complain_str) {
            // send complain to server
            let complainObj = PFObject(className: "complain")
            complainObj["by"] = PFUser.current()?.username
            complainObj["to"] = cell.uuidLbl.text!
            complainObj["owner"] = cell.usernameBtn.titleLabel?.text!
            complainObj.saveInBackground(block: { (success:Bool, error:Error?) in
                if error == nil {
                    if success {
                        let okbtn = DefaultButton(title: ok_str, action: nil)
                        let complMenu = PopupDialog(title: complain_str, message: complain_confirmation_str)
                        complMenu.addButtons([okbtn])
                        self.present(complMenu, animated: true, completion: nil)
                    } else {
                        print(error!.localizedDescription)
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
        
        // PUBLISH ACTION
        if publishedArray[i.row] {
            alertMsg = hide_str
        } else {
            alertMsg = publish_str
        }
        let publish = DefaultButton(title: alertMsg) {
            
        // STEP 1. Find post on the server
        let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
        postQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                for object in objects! {
                    if self.publishedArray[i.row] {
                        object["isPublished"] = false
                    } else {
                        object["isPublished"] = true
                    }
                    object.saveInBackground(block: { (success: Bool, error: Error?) in
                        if success {
                            
                            // send notification to rootViewController to update shown posts
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
                            
                            // push back
                            _ = self.navigationController?.popViewController(animated: true)
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        }
        
        // CANCEL ACTION
        let cancel = CancelButton(title: cancel_button_str, action: nil)
        
        // finding affected post and to display its picture in dialog box
        let dlgImg = resizeImage(cell.picImg.image!, targetSize: CGSize(width: 300.0, height: 300.0))
        
        // create menu controller
        if cell.usernameBtn.titleLabel?.text == PFUser.current()?.username {            
            if alertMsg == hide_str {
                alertMsg = deletion_article_description + " " + hide_article_description
            } else {
                alertMsg = deletion_article_description + " " + show_article_description
            }
        } else {
            alertMsg = complain_article_description
        }
        let menu = PopupDialog(title: question_what_to_do_with_article, message: alertMsg, image: dlgImg)

        // if post belongs to user, he can delete post, else he can't
        if cell.usernameBtn.titleLabel?.text == PFUser.current()?.username {
            menu.addButtons([del, publish, cancel])
        } else {
            menu.addButtons([compl, cancel])
        }
        
        // show menu
        self.present(menu, animated: true, completion: nil)
        
    }
     
}
