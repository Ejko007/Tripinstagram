//
//  rateVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

var rateuuid = [String]()
var rateowner = [String]()

class rateVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    // UI objects
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var rateInputView: CosmosView!

    
    var refresher = UIRefreshControl()
    var placeholderLbl = UILabel()
    
    
    // values for resetting UI to default
    var tableViewHeight : CGFloat = 0
    var commentY : CGFloat = 0
    var commentHeight : CGFloat = 0
    var rateY : CGFloat = 0
    var rateHeight : CGFloat = 0
    
    
    // arrays to hold server data
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var rateTxtArray = [String]()
    var ratingArray = [Double]()
    var dateArray = [NSDate?]()
    
    // variable to hold keyboard frame
    var keyboard = CGRect()
    
    // page size
    var page : Int32 = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView.backgroundColor = .red

        // title at the top
        self.navigationItem.title = rates_str.uppercased()
        
        // new back button
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backBtn
        
        // swipe to go back
        let backSwipe = UISwipeGestureRecognizer(target: self, action: #selector(back(sender:)))
        backSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(backSwipe)
        
        // catch notification if the keyboard is shown or hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // disable button from the beginning
        sendBtn.isEnabled = false
        
        // rateview initial setyting
        rateInputView.rating = 0.0
        rateInputView.settings.fillMode = .precise
        
        // create placeholder label programatically
        let placeholderX : CGFloat = self.view.frame.size.width / 75
        let placeholderY : CGFloat = 0
        let placeholderWidth = commentTxt.bounds.width - placeholderX
        let placeholderHeight = commentTxt.bounds.height
        let placeholderFontSize = self.view.frame.size.width / 25
        
        placeholderLbl.frame = CGRect(x: placeholderX, y: placeholderY, width: placeholderWidth, height: placeholderHeight)
        placeholderLbl.text = enter_text_str
        placeholderLbl.font = UIFont(name: "HelveticaNeue", size: placeholderFontSize)
        placeholderLbl.textColor = UIColor.lightGray
        placeholderLbl.textAlignment = NSTextAlignment.left
        commentTxt.addSubview(placeholderLbl)
        
        // call alignement function
        alignement()
        
        // call pagination func
        loadRates()
        
    }

    // func loading when keyboard is hidden
    func keyboardWillHide (notification: NSNotification) {
        
        // move UI down
        // move UI up
        UIView.animate(withDuration: 0.4) {
            self.tableView.frame.size.height = self.tableViewHeight
            self.commentTxt.frame.origin.y = self.commentY
            self.sendBtn.frame.origin.y = self.commentY
            self.rateInputView.frame.origin.y = self.rateY
        }
    }
   
    // func loading when keyboard is shown
    func keyboardWillShow (notification: NSNotification) {
        
        // define keyboard frame size
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // move UI up
        UIView.animate(withDuration: 0.4) {
            self.tableView.frame.size.height = self.tableViewHeight - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight + self.rateHeight
            self.commentTxt.frame.origin.y = self.commentY - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight + self.rateHeight
            self.rateInputView.frame.origin.y = self.rateY - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight + self.rateHeight
            self.sendBtn.frame.origin.y = self.commentTxt.frame.origin.y
        }
    }
    
    // load comments function
    func loadRates () {
        
        // STEP 1. Count total comments in order to skip all except (page size = 15)
        let countQuery = PFQuery(className: "rates")
        countQuery.whereKey("uuid", equalTo: rateuuid.last!)
        countQuery.countObjectsInBackground (block: { (count: Int32, error: Error?) in
            if error == nil {
                
                // if comments on the server for current post are more than (page size - 15), impleent pull to refresh func
                if self.page < count {
                    self.refresher.addTarget(self, action: #selector(self.loadMore), for: UIControlEvents.valueChanged)
                    self.tableView.addSubview(self.refresher)
                }
                
            } else {
                print(error!.localizedDescription)
            }
            
            // STEP 2. Request last (page size = 15) comments
            let query = PFQuery(className: "rates")
            query.whereKey("uuid", equalTo: rateuuid.last!)
            query.skip = count - self.page
            query.addAscendingOrder("createdAt")
            
            query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    
                    // clean up
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.avaArray.removeAll(keepingCapacity: false)
                    self.rateTxtArray.removeAll(keepingCapacity: false)
                    self.ratingArray.removeAll(keepingCapacity: false)
                    self.dateArray.removeAll(keepingCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.usernameArray.append(object.object(forKey: "username") as! String)
                        self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                        self.rateTxtArray.append(object.object(forKey: "ratingtxt") as! String)
                        self.ratingArray.append(object.object(forKey: "rating") as! Double)
                        self.dateArray.append(object.createdAt as NSDate?)
                        self.tableView.reloadData()
                        
                        // scroll to bottom
                        self.tableView.scrollToRow(at: NSIndexPath(row: self.rateTxtArray.count - 1, section: 0) as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
        })
    }
    
    // pagination
    func loadMore() {
        
        // STEP 1. Count total comments in order to skip all except (page size = 15)
        let countQuery = PFQuery(className: "rates")
        countQuery.whereKey("uuid", equalTo: rateuuid.last!)
        countQuery.countObjectsInBackground(block:{ (count: Int32, error: Error?) in
            if error == nil {
                
                // self refresher
                self.refresher.endRefreshing()
                
                // remove refresher if loaded all comments
                if self.page >= count {
                    self.refresher.removeFromSuperview()
                }
                
                // STEP 2. Load more rates
                if self.page < count {
                    
                    // increase page size plus 15
                    self.page += 15
                    
                    // request existing rates from the server
                    let query = PFQuery(className: "rates")
                    query.whereKey("uuid", equalTo: rateuuid.last!)
                    query.skip = count - self.page
                    query.addAscendingOrder("createdAt")
                    query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                        if error == nil {
                            
                            // clean up
                            self.usernameArray.removeAll(keepingCapacity: false)
                            self.avaArray.removeAll(keepingCapacity: false)
                            self.rateTxtArray.removeAll(keepingCapacity: false)
                            self.ratingArray.removeAll(keepingCapacity: false)
                            self.dateArray.removeAll(keepingCapacity: false)
                            
                            // find related objects
                            for object in objects! {
                                
                                self.usernameArray.append(object.object(forKey: "username") as! String)
                                self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                                self.rateTxtArray.append(object.object(forKey: "ratingtxt") as! String)
                                self.ratingArray.append(object.object(forKey: "rating") as! Double)
                                self.dateArray.append(object.createdAt as NSDate?)
                                self.tableView.reloadData()
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
    
    
    // TABLEVIEW
    // cell numb
    // display info when view is empty
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSections: Int = 0
        if rateTxtArray.count != 0 {
            tableView.backgroundView = nil
            tableView.separatorStyle = .none
            numOfSections = 1
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = no_data_available
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rateTxtArray.count
    }
    
    // cell height
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // cell configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // declare cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! rateCell
        
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: .normal)
        cell.usernameBtn.sizeToFit()
        cell.commentLbl.text = rateTxtArray[indexPath.row]
        cell.rateView.rating = ratingArray[indexPath.row]
        avaArray[indexPath.row].getDataInBackground (block: { (data: Data?, error: Error?) in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        })
        
        // calculate date
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
            cell.dateLbl.text = "\(difference.weekOfMonth!)" + weeks_abbrav_str .lowercased() + "."
        }
        
        // @mension is tapped
        cell.commentLbl.userHandleLinkTapHandler = { label, handle, rang in
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
        cell.commentLbl.hashtagLinkTapHandler = { label, handle, range in
            var mention = handle
            mention = String(mention.characters.dropFirst())
            hashtag.append(mention.lowercased())
            let hashvc = self.storyboard?.instantiateViewController(withIdentifier: "hashtagsVC") as! hashtagsVC
            self.navigationController?.pushViewController(hashvc, animated: true)
        }
        
        // assign indexes of buttons
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }
    
    
    // cell editability
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return rateowner.last != PFUser.current()?.username
    }
    
    // swipe cell for actions
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // call cell for calling further cell data
        let cell = tableView.cellForRow(at: indexPath) as! rateCell
        
        // ACTION 1. Delete
        let delete = UITableViewRowAction(style: .normal, title: "    ") { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont(name:"Helvetica", size:12)

            // STEP 1. Delete rate from server
            let commentQuery = PFQuery(className: "rates")
            commentQuery.whereKey("uuid", equalTo: rateuuid.last!)
            commentQuery.whereKey("ratingtxt", equalTo: cell.commentLbl.text!)
            commentQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                } else {
                    print(error!.localizedDescription)
                }
            })
            
            // close cell
            tableView.setEditing(false, animated: true)
        
            // STEP 2. Delete row from tableView
            self.rateTxtArray.remove(at: indexPath.row)
            self.ratingArray.remove(at: indexPath.row)
            self.dateArray.remove(at: indexPath.row)
            self.usernameArray.remove(at: indexPath.row)
            self.avaArray.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        }
        
        // ACTION 2. Delete notification: rate
        let newsQuery = PFQuery(className: "news")
        newsQuery.whereKey("by", equalTo: cell.usernameBtn.titleLabel!.text!)
        newsQuery.whereKey("to", equalTo: rateowner.last!)
        newsQuery.whereKey("uuid", equalTo: rateuuid.last!)
        newsQuery.whereKey("type", containedIn: ["rate"])
        newsQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                for object in objects! {
                    object.deleteEventually()
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        
        // ACTION 3. Mention or address message to someone
        let address = UITableViewRowAction(style: .normal, title: "    ") { (ation: UITableViewRowAction, indexPath: IndexPath) -> Void in
                
            // include username in textView
            self.commentTxt.text = "\(self.commentTxt.text + "@" + self.usernameArray[indexPath.row] + " ")"
            
            // enable button
            self.sendBtn.isEnabled = true
            
            // close cell - swipe it back
            tableView.setEditing(false, animated: true)
        }
            
        // ACTION 4. Complain
        let complain = UITableViewRowAction(style: .normal, title: "    ") { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            // send complain to server regarding selected comment
            let complainObj = PFObject(className: "complain")
            complainObj["by"] = PFUser.current()?.username
            complainObj["to"] = cell.commentLbl.text
            complainObj["owner"] = cell.usernameBtn.titleLabel?.text
            complainObj.saveInBackground(block: { (success: Bool, error: Error?) in
                if error == nil {
                    if success {
                        self.alert(title: "Námitka byla úspěšně vytvořena.", message: "Děkujem! Zvážime vaši připomínku.")
                    } else {
                        self.alert(title: "Chyba", message: (error?.localizedDescription)!)
                    }
            
                } else {
                    print(error!.localizedDescription)
                }
            })
            // close cell
            tableView.setEditing(false, animated: true)
        }
        
        // button background
        //delete.backgroundColor = UIColor.red
        delete.backgroundColor = UIColor(patternImage: UIImage(named: "delete.png")!)
        address.backgroundColor = UIColor(patternImage: UIImage(named: "address.png")!)
        complain.backgroundColor = UIColor(patternImage: UIImage(named: "complain.png")!)
        
        // comment belongs to user
        if cell.usernameBtn.titleLabel?.text == PFUser.current()?.username {
            return [delete, address]
        }
        
        // post belongs to user
        else if rateowner.last == PFUser.current()?.username {
            return [delete, address, complain]
        }
        
        // post belongs to other user
        else {
            return [address, complain]
        }
        
    }
    
    // alert action
    func alert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
    }
    
    // go back - back function
    func back(sender: UIBarButtonItem) {
        
        // push back
        _ = self.navigationController?.popViewController(animated: true)
        
        // clean comment uuid from last holding information
        if !rateuuid.isEmpty {
            rateuuid.removeLast()
        }
        
        // clean comment owner from last holding information
        if !rateowner.isEmpty {
            rateowner.removeLast()
        }
    }
    
    // preload function
    override func viewWillAppear(_ animated: Bool) {
        
        // hide bottom bar
        self.tabBarController?.tabBar.isHidden = false
        
        // call keyboard
        commentTxt.becomeFirstResponder()
    }
    
    // postload function
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // alignement function
    func alignement () {
        
        // alignement
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        tableView.frame = CGRect(x: 0, y: 0, width: width, height: height / 1.096 - (self.navigationController?.navigationBar.frame.size.height)! - 20 - self.rateInputView.frame.size.height - 25)
        tableView.estimatedRowHeight = width / 5.333
        tableView.rowHeight = UITableViewAutomaticDimension
        
        commentTxt.frame = CGRect(x: 10, y: tableView.frame.size.height + height / 56.8, width: width / 1.306, height: 33)
        commentTxt.layer.cornerRadius = commentTxt.frame.size.width / 50
        
        rateInputView.frame = CGRect(x: 10, y: commentTxt.frame.origin.y + 40, width: width / 1.306, height: 15)
        
        sendBtn.frame = CGRect(x: commentTxt.frame.origin.x + commentTxt.frame.size.width + width / 32, y: commentTxt.frame.origin.y, width: width - (commentTxt.frame.origin.x + commentTxt.frame.size.width) - (width / 32) * 2, height: commentTxt.frame.size.height)
        
        // delegates
        commentTxt.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // assign resetting values
        tableViewHeight = tableView.frame.size.height
        commentHeight = commentTxt.frame.size.height
        rateHeight = rateInputView.frame.size.height
        commentY = commentTxt.frame.origin.y
        rateY = rateInputView.frame.origin.y
       
        // check if rates are created by feed owner or not
        if rateowner.last == PFUser.current()?.username {
            
            // disable send button
            sendBtn.isHidden = true
            rateInputView.isHidden = true
            commentTxt.isHidden = true
            commentTxt.frame.size.height = 0
            commentTxt.frame.size.width = 0
            commentTxt.isEditable = false
            tableViewHeight = 0
        }
        
    }

    // while writing something
    func textViewDidChange(_ textView: UITextView) {
        
        // disable button if entered no text
        let spacing = NSCharacterSet.whitespacesAndNewlines
        
        // entered text
        if !commentTxt.text.trimmingCharacters(in: spacing).isEmpty {
            sendBtn.isEnabled = true
            placeholderLbl.isHidden = true
        // text is not entered
        } else {
            sendBtn.isEnabled = false
            placeholderLbl.isHidden = false
        }
        
        // + paragaraph
        if textView.contentSize.height > textView.frame.size.height && textView.frame.height < 130 {
            
            // find difference to add
            let difference = textView.contentSize.height - textView.frame.size.height
            
            // redefine frame of commentTxt
            textView.frame.origin.y = textView.frame.origin.y - difference
            textView.frame.size.height = textView.contentSize.height
            
            // move up tableView
            if textView.contentSize.height + keyboard.height + commentY + rateY >= tableView.frame.size.height {
                tableView.frame.size.height = tableView.frame.size.height - difference
            }
        }
            
        // - paragraph
        else if textView.contentSize.height < textView.frame.size.height {
            
            // find difference to deduct
            let difference = textView.frame.size.height - textView.contentSize.height
            
            // redefine frame of commentTxt
            textView.frame.origin.y = textView.frame.origin.y + difference
            textView.frame.size.height = textView.contentSize.height
            
            // move down tableView
            if textView.contentSize.height + keyboard.height + commentY + rateY > tableView.frame.size.height {
                tableView.frame.size.height = tableView.frame.size.height + difference
            }
         }
    }
    
    // clicked send button
    @IBAction func sendBtn_click(_ sender: AnyObject) {
        
        // STEP 1. Add row in tableView
        usernameArray.append(PFUser.current()!.username!)
        avaArray.append(PFUser.current()?.object(forKey: "ava") as! PFFile)
        dateArray.append(NSDate())
        rateTxtArray.append(commentTxt.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines))
        ratingArray.append(rateInputView.rating)
        tableView.reloadData()
        
        // STEP 2. Send rate to server
        let rateObj = PFObject(className: "rates")
        rateObj["uuid"] = rateuuid.last
        rateObj["username"] = PFUser.current()?.username
        rateObj["ava"] = PFUser.current()?.value(forKey: "ava")
        rateObj["ratingtxt"] = commentTxt.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        rateObj["rating"] = rateInputView.rating
        rateObj.saveEventually()
        
        // STEP 3. Send #hashtag to server
        let words: [String] = commentTxt.text!.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        
        // define tagged word
        for var word in words {
            
            // save #hashtag in server
            if word.hasPrefix("#") {
                
                // cut symbol
                word = word.trimmingCharacters(in: NSCharacterSet.punctuationCharacters)
                word = word.trimmingCharacters(in: NSCharacterSet.symbols)
                
                let hashtagObj = PFObject(className: "hashtags")
                hashtagObj["to"] = rateuuid.last
                hashtagObj["by"] = PFUser.current()?.username
                hashtagObj["hashtag"] = word.lowercased()
                hashtagObj["comment"] = commentTxt.text
                hashtagObj.saveInBackground(block: { (success: Bool, error: Error?) in
                    if error == nil {
                        if success {
                            print("hashtag \(word) is created")
                        }
                        
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                })
            }
        }
        
        // STEP 4. Send notification as @mention
        var mentionCreated = Bool()
        
        for var word in words {
            
            // check @mentions for user
            if word.hasPrefix("@") {
                
                // cup symbols
                word = word.trimmingCharacters(in: NSCharacterSet.punctuationCharacters)
                word = word.trimmingCharacters(in: NSCharacterSet.symbols)
                
                let newsObj = PFObject(className: "news")
                newsObj["by"] = PFUser.current()?.username
                newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
                newsObj["to"] = word
                newsObj["owner"] = rateowner.last
                newsObj["uuid"] = rateuuid.last
                newsObj["type"] = "mention"
                newsObj["checked"] = "no"
                newsObj.saveEventually()
                
                mentionCreated = true
            }
        }
        
        // STEP 5. Send notification as rate
        if rateowner.last != PFUser.current()?.username && mentionCreated == false {
            
            let newsObj = PFObject(className: "news")
            newsObj["by"] = PFUser.current()?.username
            newsObj["ava"] = PFUser.current()?.object(forKey: "ava") as! PFFile
            newsObj["to"] = rateowner.last
            newsObj["owner"] = rateowner.last
            newsObj["uuid"] = rateuuid.last
            newsObj["type"] = "rate"
            newsObj["checked"] = "no"
            newsObj.saveEventually()
        }
        
        // scroll to bottom
        self.tableView.scrollToRow(at: NSIndexPath(row: self.rateTxtArray.count - 1, section: 0) as IndexPath, at: UITableViewScrollPosition.bottom, animated: false)

        // STEP 6. Reset UI
        sendBtn.isEnabled = false
        placeholderLbl.isHidden = false
        commentTxt.text = ""
        commentTxt.frame.size.height = commentHeight
        rateInputView.rating = 0.0
        rateInputView.frame.size.height = rateHeight
        commentTxt.frame.origin.y = sendBtn.frame.origin.y
        tableView.frame.size.height = self.tableViewHeight - self.keyboard.height - self.commentTxt.frame.size.height + self.commentHeight + self.rateHeight
    }
    
    // clicked username button
    @IBAction func usernameBtn_click(_ sender: AnyObject) {
        
        // call index of current button
        let i  = sender.layer.value(forKey: "index")
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i as! IndexPath) as! rateCell
        
        // if user tapped his username go home, otherwise go guest
        if cell.usernameBtn.titleLabel?.text == PFUser.current()?.username {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append(cell.usernameBtn.titleLabel!.text!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
    
}
