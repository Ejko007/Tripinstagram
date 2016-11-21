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
    
    var ratingArray = [Double]()
    
    var publishedArray = [Bool]()
    
    // default finction
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // title label at the top
        self.navigationItem.title = photo_str.uppercased()
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))

        //let backBtn = UIBarButtonItem(title: "Zpět", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // new edit button
        let editBtn = UIBarButtonItem(image: UIImage(named: "edit.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = editBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "liked"), object: nil)
        
        // dynamic height cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 450
        
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
                print(error?.localizedDescription as Any)
            }
        })
        
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
            cell.dateLbl.text = now_str
        }
        
        if difference.second! > 0 && difference.minute! == 0 {
            cell.dateLbl.text = "\(difference.second!)"+seconds_abbrav_str+"."
        }
        
        if difference.minute! > 0 && difference.hour! == 0 {
            cell.dateLbl.text = "\(difference.minute!)"+minutes_abbrav_str+"."
            
        }
        
        if difference.hour! > 0 && difference.day! == 0 {
            cell.dateLbl.text = "\(difference.hour!)"+hours_abbrav_str+"."
        }
        
        if difference.day! > 0 && difference.weekOfMonth! == 0 {
            cell.dateLbl.text = "\(difference.day!)"+days_abbrav_str+"."
        }
        
        if difference.weekOfMonth! > 0 {
            cell.dateLbl.text = "\(difference.weekOfMonth!)"+weeks_abbrav_str+"."
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

        // assign rates value
        cell.rateView.updateOnTouch = false
        cell.rateView.rating = 0.0
        
        let countRates = PFQuery(className: "rates")
        countRates.whereKey("uuid", equalTo: cell.uuidLbl.text!)
        countRates.findObjectsInBackground(block: { (ratesObjects: [PFObject]?, ratesError: Error?) in

            var sumaRates: Double = 0.0

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
        cell.rateBtn.layer.setValue(indexPath, forKey: "index")
        cell.isPublished.layer.setValue(indexPath, forKey: "index")
        
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
        let dlgImg = resizeImage(cell.picImg.image!, targetSize: CGSize(width: 300.0, height: 300.0))
        
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
    
    
    // edit button function
    func edit() {
        
        
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
    
}
