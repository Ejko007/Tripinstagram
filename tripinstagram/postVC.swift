//
//  postVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog
import ExpandingMenu
import MapKit
import Social

var postuuid = [String]()

class postVC: UITableViewController {
    

    // arrays to hold information from server
    var avaArray = [PFFile]()
    var usernameArray = [String]()
    var genderArray = [String]()
    var dateArray = [Date?]()
    
    var picArray = [PFFile]()
    var uuidArray = [String]()
    var titleArray = [String]()
    var personsNrArray = [Int]()
    var totalDistanceArray = [Double]()
    var tripFromArray = [Date?]()
    var tripToArray = [Date?]()
    var levelArray = [Int]()
    var countriesArray = Array<Array<String>>()

    var ratingArray = [Double]()
    
    var publishedArray = [Bool]()
        
    // default finction
    override func viewDidLoad() {
        
        var countries = [String]()

        super.viewDidLoad()
        
        // setup cell height dynamicly
        self.tableView.estimatedRowHeight = UIScreen.main.bounds.width
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // title label at the top
        self.navigationItem.title = photo_str.uppercased()
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))

        //let backBtn = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // new edit button
        let editBtn = UIBarButtonItem(image: UIImage(named: "edit.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(edit))
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
                
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "liked"), object: nil)
        
        // dynamic height cell
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 350
        
        // find post
        let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackground (block: { (objects: [PFObject]?, error: Error?) in
            
            if error == nil {
                
                // clean up
                self.avaArray.removeAll(keepingCapacity: false)
                self.usernameArray.removeAll(keepingCapacity: false)
                self.genderArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                self.titleArray.removeAll(keepingCapacity: false)
                self.ratingArray.removeAll(keepingCapacity: false)
                self.publishedArray.removeAll(keepingCapacity: false)
                self.personsNrArray.removeAll(keepingCapacity: false)
                self.totalDistanceArray.removeAll(keepingCapacity: false)
                self.tripFromArray.removeAll(keepingCapacity: false)
                self.tripToArray.removeAll(keepingCapacity: false)
                self.levelArray.removeAll(keepingCapacity: false)
                countries.removeAll(keepingCapacity: false)
                self.countriesArray.removeAll(keepingCapacity: false)
                
                //find related objects
                for object in objects! {
                    self.avaArray.append(object.value(forKey: "ava") as! PFFile)
                    self.usernameArray.append(object.value(forKey: "username") as! String)
                    self.genderArray.append(object.value(forKey: "gender") as! String)
                    self.dateArray.append(object.createdAt as Date?)
                    self.picArray.append(object.value(forKey: "pic") as! PFFile)
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.titleArray.append(object.value(forKey: "title") as! String)
                    self.publishedArray.append(object.value(forKey: "isPublished") as! Bool)
                    self.personsNrArray.append(object.value(forKey: "personsNr") as! Int)
                    self.totalDistanceArray.append(object.value(forKey: "totalDistance") as! Double)
                    self.tripFromArray.append(object.value(forKey: "tripFrom") as! Date?)
                    self.tripToArray.append(object.value(forKey: "tripTo") as! Date?)
                    self.levelArray.append(object.value(forKey: "level") as! Int)
                    countries.removeAll(keepingCapacity: false)
                    countries = object.object(forKey: "countries") as! [String]
                    // countries = object["countries"] as! [String]
                    self.countriesArray.append(countries)
                    
                    // counting rates
                    var sumaRates: Double = 0.0
                    self.ratingArray.append(sumaRates)
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
                            self.ratingArray.remove(at: Int(self.ratingArray.last!))
                            self.ratingArray.append(sumaRates)
                        } else {
                            print(ratesError!.localizedDescription)
                        }
                    })
                 }
                
                self.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
            
            // show edit button for current user post only
            if (self.usernameArray.count == 1) && (PFUser.current()?.username == self.usernameArray.last?.lowercased()) {
                self.navigationItem.rightBarButtonItems = [editBtn]
                editBtn.isEnabled = true
            } else {
                self.navigationItem.rightBarButtonItems = []
                editBtn.isEnabled = false
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide expanding menu
        configureExpandingMenuButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // dismiss expanding menu
        self.tabBarController?.view.subviews.last?.isHidden = true
        
    }
    
    // fading and animation effects
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // define initial state (before the animation)
        cell.alpha = 0
        //let rotationAngleInRadians = 90.0 * CGFloat(M_PI/180.0)
        //let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1)
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 100, 0)
        cell.layer.transform = rotationTransform
        
        // define the final state (after the animation)
        UIView.animate(withDuration: 1.0, animations: {cell.alpha = 1})
        UIView.animate(withDuration: 1.0, animations: {cell.layer.transform = CATransform3DIdentity})
  
        // fading animation
        let gradient = CAGradientLayer()
        gradient.frame = cell.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        tableView.layer.insertSublayer(gradient, at: 0)
        
    }


    // number of cells
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernameArray.count
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
        
        // place country flag
        //Add your images
        var flagsImageArray = [UIImage]()
        var countItems = Int()
        var flagsCodes = [String]()
        var subview = UIImageView()
        
        flagsCodes.removeAll(keepingCapacity: false)
        
        flagsCodes = countriesArray[indexPath.row]
        countItems = flagsCodes.count
        if countItems > 14 {
            countItems = 13
        }
        
        flagsImageArray.removeAll(keepingCapacity: false)
        
        for j in 0...countItems - 1 {
            if let flagImage = UIImage(named: IsoCountryCodes.searchByName(name: flagsCodes[j]).alpha2) {
                flagsImageArray.append(flagImage)
            } else {
                flagsImageArray.append(UIImage(named: "WW")!)
            }
        }
        
        // remove all subviews
        for view in cell.countriesView.subviews {
            view.removeFromSuperview()
        }
        
        var count = 0
        for i in 0...countItems - 1 {
            //Add a subview at the position
            subview = UIImageView(frame: CGRect(x: 0, y: 20 * CGFloat(i), width: 30, height: 20))
            subview.image = flagsImageArray[count]
            //self.view.addSubview(subview)
            cell.countriesView.addSubview(subview)
            count += 1
        }
        
        // place post picture
        picArray[indexPath.row].getDataInBackground(block: { (data: Data?, error: Error?) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print (error!.localizedDescription)
            }
        })
        
        // count total spents of showing post
        let countSpents = PFQuery(className: "tripspents")
        countSpents.whereKey("uuid", equalTo: cell.uuidLbl.text!)
        countSpents.findObjectsInBackground(block: { (spentsObjects: [PFObject]?, spentsError: Error?) in
            var sumaSpents: Double = 0.0
            
            if spentsError == nil {
                
                // calculate total spents
                for spentsObject in spentsObjects! {
                    let spent = (spentsObject.value(forKey: "spentAmount") as! Double)
                    let spentrate = (spentsObject.value(forKey: "spentCurrencyRate") as! Double)
                    sumaSpents = sumaSpents + (spent * spentrate)
                }
            } else {
                print(spentsError!.localizedDescription)
            }
            cell.totalSpentsLbl.text = String(format: "%.2f", sumaSpents)
        })
        
        // assign index
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }
    
    // clicked username button
    @IBAction func usernameBtn_click(_ sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.value(forKey: "index") as! NSIndexPath
        
        // call cell to call further data
        let cell = tableView.cellForRow(at: i as IndexPath) as! postCell
        
        // if user tapped on himself go home - otherwise go guest
        if cell.usernameBtn.titleLabel?.text == PFUser.current()?.username {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append((cell.usernameBtn.titleLabel!.text)!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
    
    
    // clicked rate button / view
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
                if count == 0 {
                    let okbtn = DefaultButton(title: ok_str, action: nil)
                    let complMenu = PopupDialog(title: rates_str, message: no_rates_str)
                    complMenu.addButtons([okbtn])
                    self.present(complMenu, animated: true, completion: nil)
                } else {
                    // go to rates. present its VC
                    
                    let rate = self.storyboard?.instantiateViewController(withIdentifier: "rateVC") as! rateVC
                    self.navigationController?.pushViewController(rate, animated: true)
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
            self.uuidArray.remove(at: i.row)
            self.ratingArray.remove(at: i.row)
            self.publishedArray.remove(at: i.row)
            self.personsNrArray.remove(at: i.row)
            self.totalDistanceArray.remove(at: i.row)
            self.tripFromArray.remove(at: i.row)
            self.tripToArray.remove(at: i.row)
            self.levelArray.remove(at: i.row)
            self.countriesArray.remove(at: i.row)
            
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
            
            // STEP 8. Delete photos of post from the server
            let photoQuery = PFQuery(className: "photos")
            photoQuery.whereKey("uuid", equalTo: cell.uuidLbl.text!)
            photoQuery.findObjectsInBackground(block: { (photosobjects: [PFObject]?, photoserror: Error?) in
                if photoserror == nil {
                    
                    for photoobject in photosobjects! {
                        photoobject.deleteEventually()
                    }
                } else {
                    print(photoserror!.localizedDescription)
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
        
        // RATE ACTION
        let rate = DefaultButton(title: rate_it_str) {
            
            // call index of button
            let i = sender.layer.value(forKey: "index") as! NSIndexPath
            
            // call cell to call further cell data
            let cell = self.tableView.cellForRow(at: i as IndexPath) as! postCell
            
            // send related data to global variables
            rateuuid.append(cell.uuidLbl.text!)
            rateowner.append(cell.usernameBtn.titleLabel!.text!)
            
            // go to rates. present its VC
            let rateVC = self.storyboard?.instantiateViewController(withIdentifier: "rateVC") as! rateVC
            self.navigationController?.pushViewController(rateVC, animated: true)
        }

        
        // CANCEL ACTION
        // let cancel = UIAlertAction (title: "Zrušit", style: .cancel, handler: nil)
        let cancel = CancelButton(title: cancel_button_str, action: nil)
        
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
        
        // finding affected post and to display its picture in dialog box        
        let dlgImg = resizeImage(cell.picImg.image!, targetSize: CGSize(width: 200.0, height: 200.0))
        
        let menu = PopupDialog(title: question_what_to_do_with_article, message: alertMsg, image: dlgImg)
        
        // if post belongs to user, he can delete post, else he can't
        if cell.usernameBtn.titleLabel?.text == PFUser.current()?.username {
            menu.addButtons([del, publish, cancel])
        } else {
            menu.addButtons([compl, rate, cancel])
        }
            
        // show menu
        self.present(menu, animated: true, completion: nil)
        
    }
    
    // open segue to editPost view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editPost" {
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            _ = storyboard.instantiateViewController(withIdentifier: "uploadEditVC") as! uploadEditVC

            //self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    // edit button function
    func edit() {
        self.performSegue(withIdentifier: "editPost", sender: self)
    }
    
    // go back function
    func back(sender: UIBarButtonItem) {
        
        //push back
        _ = self.navigationController?.popViewController(animated: true)
        
        // clean post uuid from last hold
        if !postuuid.isEmpty {
            postuuid.removeLast()
        }
        
    }
    
    // refreshing function
    func refresh () {
        self.tableView.reloadData()
    }
    
    // configuring expanding menu
    fileprivate func configureExpandingMenuButton() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let menuButtonSize: CGSize = CGSize(width: 30.0, height: 30.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "chooser-button-tab")!, centerHighlightedImage: UIImage(named: "chooser-button-tab-highlighted")!)
        // menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: self.view.bounds.height - 72.0)
        menuButton.center = CGPoint(x: self.view.bounds.width - 32.0, y: (self.tabBarController?.view.bounds.height)! - 72.0)
        self.tabBarController?.view.addSubview(menuButton)
        //self.view.addSubview(menuButton)
        
        func showAlert(_ title: String) {
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: spents_menu_str, image: UIImage(named: "Coins")!, highlightedImage: UIImage(named: "chooser-moment-icon-place-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            //showAlert("Music")
            
            let spentViewController = storyBoard.instantiateViewController(withIdentifier: "spentsVC") as! spentsVC
            self.navigationController!.pushViewController(spentViewController, animated: true)
            
            // delegate uuid for displaying spents
            spentViewController.username = (self.usernameArray.last?.lowercased())!
            spentViewController.uuid = self.uuidArray.last!
            
            // self.present(spentViewController, animated:true, completion:nil)
        }
        
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: triproute_menu_str, image: UIImage(named: "chooser-moment-icon-place")!, highlightedImage: UIImage(named: "chooser-moment-icon-place-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            //showAlert("Place")
            
            // initialize global arrays to save memmory
            geoplacemarkArray.removeAll(keepingCapacity: false)
            itineraryInstructions.removeAll(keepingCapacity: false)
            itineraryInstructionsArray.removeAll(keepingCapacity: false)
            itineraryDistances.removeAll(keepingCapacity: false)
            
            //let mapViewController = storyBoard.instantiateViewController(withIdentifier: "tripMapVC") as! tripMapVC
            let mapViewController = storyBoard.instantiateViewController(withIdentifier: "tripMapMasterVC") as! tripMapMasterVC
            self.navigationController!.pushViewController(mapViewController, animated: true)

            // delegate uuid for displaying map
            //
            mapViewController.username = (self.usernameArray.last?.lowercased())!
            mapViewController.uuid = self.uuidArray.last!

            // self.present(mapViewController, animated:true, completion:nil)
        }
        
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: camera_str, image: UIImage(named: "chooser-moment-icon-camera")!, highlightedImage: UIImage(named: "chooser-moment-icon-camera-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            // showAlert(camera_str)

            // delegate uuid for displaying photogallery
            let photoViewController = storyBoard.instantiateViewController(withIdentifier: "photoGalleryVC") as! HomeViewController
            self.navigationController!.pushViewController(photoViewController, animated: true)
            
            photoViewController.tripuuid = self.uuidArray.last!
            photoViewController.username = (self.usernameArray.last?.lowercased())!
        }
        
        let item4 = ExpandingMenuItem(size: menuButtonSize, title: thought_str, image: UIImage(named: "chooser-moment-icon-thought")!, highlightedImage: UIImage(named: "chooser-moment-icon-thought-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            showAlert(thought_str)
        }
        
        let item5 = ExpandingMenuItem(size: menuButtonSize, title: trip_details, image: UIImage(named: "chooser-moment-icon-sleep")!, highlightedImage: UIImage(named: "chooser-moment-icon-sleep-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            //showAlert("Sleep")
            
            
            let tripsListViewController = storyBoard.instantiateViewController(withIdentifier: "PBRevealViewController") as! PBRevealViewController
            self.present(tripsListViewController, animated:true, completion:nil)
            
            // delegate uuid for displaying trips
            //tripsListViewController.username = (self.usernameArray.last?.lowercased())!
            //tripsListViewController.uuid = self.uuidArray.last!

        }
        
        menuButton.addMenuItems([item1, item2, item3, item4, item5])
        
        menuButton.willPresentMenuItems = { (menu) -> Void in
            // print("MenuItems will present.")
        }
        
        menuButton.didDismissMenuItems = { (menu) -> Void in
            // print("MenuItems dismissed.")
        }
    }
    
    @IBAction func shareButton_tapped(_ sender: UIButton) {
        
        // Get the selected row
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: buttonPosition) else {
            return
        }
        
        let cancelAction = CancelButton(title: cancel_button_str, action: nil)
        
        var tripPicture = UIImage()
        picArray[indexPath.row].getDataInBackground(block: { (data: Data?, error: Error?) in
            if error == nil {
                // get picture of trip
                tripPicture = UIImage(data: data!)!

                // Display the share menu
                let twitterAction = DefaultButton(title: twitter_str) { (action) in
                    
                    // Check if Twitter is available. Otherwise, display an error message
                    guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) else {
                        
                        let okbtn = DefaultButton(title: ok_str, action: nil)
                        let alertMessage = PopupDialog(title: twitter_unavailable, message: twitter_registration_error)
                        alertMessage.addButtons([okbtn])
                        self.present(alertMessage, animated: true, completion: nil)
                        
                        return
                    }
                    
                    // Display Tweet Composer
                    if let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                        tweetComposer.setInitialText(share_item + " ")// + self.restaurantNames[indexPath.row])
                        tweetComposer.add(tripPicture)
                        self.present(tweetComposer, animated: true, completion: nil)
                    }
                }
                
                let facebookAction = DefaultButton(title: facebook_str) { (action) in
                    
                    // Check if Facebook is available. Otherwise, display an error message
                    guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) else {
                        
                        let okbtn = DefaultButton(title: ok_str, action: nil)
                        let alertMessage = PopupDialog(title: facebook_unavailable, message: facebook_registration_error)
                        alertMessage.addButtons([okbtn])
                        self.present(alertMessage, animated: true, completion: nil)
                        
                        return
                    }
                    
                    // Display Facebook Composer
                    if let fbComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                        fbComposer.setInitialText(share_item + " ") // + self.restaurantNames[indexPath.row])
                        fbComposer.add(tripPicture)
                        // fbComposer.add(URL(string: home_application_url_str))
                        self.present(fbComposer, animated: true, completion: nil)
                    }
                }
                
                let dlgImg = resizeImage(tripPicture, targetSize: CGSize(width: 300.0, height: 300.0))
                
                let menu = PopupDialog(title: question_what_to_do_with_article, message: sharing_notification_str, image: dlgImg)
                menu.addButtons([twitterAction, facebookAction, cancelAction])
                
                self.present(menu, animated: true, completion: nil)
            } else {
                print (error!.localizedDescription)
            }
        })
    }
}
