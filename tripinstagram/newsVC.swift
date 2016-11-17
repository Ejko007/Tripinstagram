//
//  newsVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class newsVC: UITableViewController {
    
    // arrays to hold data from the server
    var usernameArray = [String]()
    var genderArray = [String]()
    var avaArray = [PFFile]()
    var typeArray = [String]()
    var dateArray = [Date?]()
    var uuidAray = [String]()
    var ownerArray = [String]()

    // default function
    override func viewDidLoad() {
        super.viewDidLoad()

        // dynamic tableView height = dynamic cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        // title at the top
        self.navigationItem.title = notifications_str.uppercased()
        
        // request notifications
        let query = PFQuery(className: "news")
        query.whereKey("to", equalTo: PFUser.current()!.username!)
        query.limit = 30
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clean up
                self.usernameArray.removeAll(keepingCapacity: false)
                self.genderArray.removeAll(keepingCapacity: false)
                self.avaArray.removeAll(keepingCapacity: false)
                self.typeArray.removeAll(keepingCapacity: false)
                self.dateArray.removeAll(keepingCapacity: false)
                self.uuidAray.removeAll(keepingCapacity: false)
                self.ownerArray.removeAll(keepingCapacity: false)
                
                // found related objects
                for object in objects! {
                    
                    self.usernameArray.append(object.object(forKey: "by") as! String)
                    self.genderArray.append(object.object(forKey: "gender") as! String)
                    self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                    self.typeArray.append(object.object(forKey: "type") as! String)
                    self.dateArray.append(object.createdAt as Date?)
                    self.uuidAray.append(object.object(forKey: "uuid") as! String)
                    self.ownerArray.append(object.object(forKey: "owner") as! String)
                    
                    // save notifications as checked
                    object["checked"] = "yes"
                    object.saveEventually()
                }
                
                // reload table to show received data
                self.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        })
    }

    // cell numb
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // declare cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! newsCell
        
        // connect cell objects with received data from server
        cell.usernameBtn.setTitle(usernameArray[indexPath.row], for: .normal)
        cell.usernameBtn.sizeToFit()
        
        // add color according to gender
        if genderArray[indexPath.row] == "male" {
            cell.usernameBtn.tintColor = .blue
        } else {
            cell.usernameBtn.tintColor = .red
        }

        avaArray[indexPath.row].getDataInBackground(block: { (data: Data?, error: Error?) in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        })
        
        // calculate post date
        let from = dateArray[indexPath.row]
        let now = Date()
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
        
        // define info text
        if typeArray[indexPath.row] == "mention" {
            cell.infoLbl.text = has_mentioned_you_str
        }
        
        if typeArray[indexPath.row] == "comment" {
            cell.infoLbl.text = has_commented_your_post_str
        }
        
        if typeArray[indexPath.row] == "follow" {
            cell.infoLbl.text = now_following_you_str
        }
        
        if typeArray[indexPath.row] == "like" {
            cell.infoLbl.text = likes_your_post_str
        }
        
        if typeArray[indexPath.row] == "rate" {
            cell.infoLbl.text = rated_your_post_str
        }

        
        // assign index of button
        cell.usernameBtn.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }
    
    // clicked username button
    @IBAction func usernameBtn_click(_ sender: AnyObject) {
        
        // call index of button
        let i = sender.layer.value(forKey: "index") as! IndexPath
        
        // call cell to call further data
        let cell = tableView.cellForRow(at: i as IndexPath) as! newsCell
        
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

    // clicked cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // define cell for calling cell data
        let cell = tableView.cellForRow(at: indexPath) as! newsCell
        
        // going to @mentioned comments
        if cell.infoLbl.text == has_mentioned_you_str {
            
            // send related data to global variable
            commentuuid.append(uuidAray[indexPath.row])
            commentowner.append(ownerArray[indexPath.row])
            
            // go comments
            let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
            self.navigationController?.pushViewController(comment, animated: true)
        }
        
        // going to own comments
        if cell.infoLbl.text == has_commented_your_post_str {
            
            // send related data to global variable
            commentuuid.append(uuidAray[indexPath.row])
            commentowner.append(ownerArray[indexPath.row])
            
            // go comments
            let comment = self.storyboard?.instantiateViewController(withIdentifier: "commentVC") as! commentVC
            self.navigationController?.pushViewController(comment, animated: true)
        }
        
        // going to user followed current user
        if cell.infoLbl.text == now_following_you_str {
            
            // take guest name
            guestname.append(cell.usernameBtn.titleLabel!.text!)
            
            // go guest
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
        
        // going to liked post
        if cell.infoLbl.text == likes_your_post_str {
            
            // take post uuid
            postuuid.append(uuidAray[indexPath.row])
            
            // go post
            let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
            self.navigationController?.pushViewController(post, animated: true)
            
        }
 
        // going to rated post
        if cell.infoLbl.text == rated_your_post_str {
            
            // take post uuid
            postuuid.append(uuidAray[indexPath.row])
            
            // go post
            let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
            self.navigationController?.pushViewController(post, animated: true)
            
        }
    }
}
