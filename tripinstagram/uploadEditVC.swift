//
//  uploadEditVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class uploadEditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TimeFrameDelegate {

    var startDate:Date?
    var endDate:Date?
    
    // arrays to hold information from server
    var dateFromArray = [Date?]()
    var dateToArray = [Date?]()
    var picArray = [PFFile]()
    var uuidArray = [String]()
    var tripNameArray = [String]()
    var personsNrArray = [Int]()
    var currencyArray = [String]()
    var totalSApentsArray = [Double]()
    var titleTxtArray = [String]()

    
    @IBOutlet weak var tripNameTxt: UITextField!
    @IBOutlet weak var pcImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var dateFromLbl: UILabel!
    @IBOutlet weak var dateToLbl: UILabel!
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var personsNrImg: UIImageView!
    @IBOutlet weak var personsNr: UILabel!
    @IBOutlet weak var spentsImg: UIImageView!
    @IBOutlet weak var totalSpentsLbl: UILabel!
    @IBOutlet weak var currencyLbl: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // title label at the top
        self.navigationItem.title = update_post_str.uppercased()
        
        // disable save btn by default
        saveBtn.isEnabled = false
        saveBtn.backgroundColor = .lightGray
        saveBtn.titleLabel!.text = save_str
        
        // hide remove button
        removeBtn.isHidden = false
        
        // hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // select image tap
        let picTap = UITapGestureRecognizer(target: self, action: #selector(selectImg))
        picTap.numberOfTapsRequired = 1
        pcImg.isUserInteractionEnabled = true
        pcImg.addGestureRecognizer(picTap)
        
        // find post
        let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackground (block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                // clean up
                self.dateFromArray.removeAll(keepingCapacity: false)
                self.dateToArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                self.tripNameArray.removeAll(keepingCapacity: false)
                self.personsNrArray.removeAll(keepingCapacity: false)
                self.currencyArray.removeAll(keepingCapacity: false)
                self.totalSApentsArray.removeAll(keepingCapacity: false)
                self.titleTxtArray.removeAll(keepingCapacity: false)
               
                //find related objects
                for object in objects! {
                    self.dateFromArray.append((object.value(forKey: "tripFrom") as! Date))
                    self.dateToArray.append((object.value(forKey: "tripTo") as! Date))
                    self.picArray.append(object.value(forKey: "pic") as! PFFile)
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.tripNameArray.append(object.value(forKey: "tripName") as! String)
                    self.personsNrArray.append(object.value(forKey: "personsNr") as! Int)
                    self.currencyArray.append(object.value(forKey: "currencyCode") as! String)
                    self.totalSApentsArray.append(object.value(forKey: "totalSpents") as! Double)
                    self.titleTxtArray.append(object.value(forKey: "title") as! String)
                 }
                
                // place post picture
                self.picArray.last?.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if error == nil {
                        self.pcImg.image = UIImage(data: data!)
                    } else {
                        print (error!.localizedDescription)
                    }
                })
                
                self.tripNameTxt.text = self.tripNameArray.last
                self.titleTxt.text = self.titleTxtArray.last
                self.personsNr.text = "\(self.personsNrArray.last!)"
                self.totalSpentsLbl.text = "\(self.totalSApentsArray.last!)"
                self.currencyLbl.text = self.currencyArray.last
                
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "dd.MM.yyy"
                self.dateFromLbl.text = dateformatter.string(from: (self.dateFromArray.last!)!)
                self.dateToLbl.text = dateformatter.string(from: (self.dateToArray.last!)!)
                
                self.startDate = GLDateUtils.date(byAddingDays: 0, to: (self.dateFromArray.last!)!) as Date
                self.endDate = GLDateUtils.date(byAddingDays: 0, to: (self.dateToArray.last!)!) as Date
                
                
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    
    // preload function
    override func viewWillAppear(_ animated: Bool) {
        
        // call alignement func
        alignement()
    }
    
    // func to call PickerViewController
    func selectImg () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // hide keyboard func
    func hideKeyboardTap () {
        self.view.endEditing(true)
    }
    
    // zooming in/out function
    func zoomImg () {
        
        
        // define frame of zoomed image
        let zoomed = CGRect(x: 0, y: self.view.center.y - self.view.center.x - self.tabBarController!.tabBar.frame.size.height * 1.5, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        // frame of unzoomed (small) image
        let unzoomed = CGRect(x: 15, y: 15, width: self.view.frame.size.width / 4.5, height: self.view.frame.size.width / 4.5)
        
        // id picture is unzoomed, zoom it
        if pcImg.frame == unzoomed {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.pcImg.frame = zoomed
                
                // hide objects from background
                self.view.backgroundColor = .black
                self.titleTxt.alpha = 0
                self.saveBtn.alpha = 0
                self.tripNameTxt.alpha = 0
                
                // hide remove button
                self.removeBtn.isHidden = true
                
            })
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.pcImg.frame = unzoomed
                
                // unhide objects from background
                self.view.backgroundColor = .white
                self.titleTxt.alpha = 1
                self.saveBtn.alpha = 1
                self.tripNameTxt.alpha = 1
                
                self.removeBtn.isHidden = false
            })
        }
    }
    
    // fields alignement function
    func alignement () {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        
        tripNameTxt.frame = CGRect(x: 15, y: 15, width: width - 30, height: 20)
        
        pcImg.frame = CGRect(x: 15, y: tripNameTxt.frame.size.height + 30, width: width / 3, height: width / 3)
        
        titleTxt.frame = CGRect(x: 15, y: 80 + pcImg.frame.size.height, width:
            width - 30, height: pcImg.frame.size.height)
        
        dateFromLbl.frame = CGRect(x: 30 + width / 3, y: tripNameTxt.frame.size.height + 30, width:
            70, height: 15)
        
        selectDateBtn.frame = CGRect(x: 30 + width / 3, y: dateFromLbl.frame.origin.y + 20, width: 30, height: 30)
        
        dateToLbl.frame = CGRect(x: 30 + width / 3, y: selectDateBtn.frame.origin.y + 35, width:
            70, height: 15)
        
        personsNrImg.frame = CGRect(x: width - 50, y: tripNameTxt.frame.size.height + 30, width: 25, height: 25)
        
        personsNr.frame = CGRect(x: width - 50, y: personsNrImg.frame.origin.y + 25, width: 30, height: 30)
        
        totalSpentsLbl.frame = CGRect(x: 30 + width / 3, y: tripNameTxt.frame.size.height + pcImg.frame.height + 5, width: width - 80 - pcImg.frame.width, height: 25)
        
        spentsImg.frame = CGRect(x: width - 50, y: totalSpentsLbl.frame.origin.y - 30, width: 25, height: 25)
        
        
        totalSpentsLbl.layer.backgroundColor  = UIColor.lightText.cgColor
        totalSpentsLbl.layer.cornerRadius = 5
        totalSpentsLbl.layer.borderColor = UIColor.darkGray.cgColor
        totalSpentsLbl.layer.borderWidth = 1.0
        let lablTextRact = CGRect(x: totalSpentsLbl.frame.origin.x + 1, y: totalSpentsLbl.frame.origin.y + 1, width: totalSpentsLbl.frame.width - 10, height: totalSpentsLbl.frame.height - 1)
        totalSpentsLbl.textAlignment = .center
        totalSpentsLbl.drawText(in: lablTextRact)
        
        currencyLbl.frame = CGRect(x: totalSpentsLbl.frame.origin.x + totalSpentsLbl.frame.width + 5, y: totalSpentsLbl.frame.origin.y, width: 25, height: 25)
        
        saveBtn.frame = CGRect(x: 0, y: height / 1.09, width: width, height: width / 8)
        
        removeBtn.frame = CGRect(x: pcImg.frame.origin.x, y: 15 + tripNameTxt.frame.origin.y + 10 + pcImg.frame.size.height + 15, width: pcImg.frame.size.width, height: 20)
    }
    
    // hold selected object and dismiss PickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        pcImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
        // enable save button
        saveBtn.isEnabled = true
        saveBtn.backgroundColor = UIColor(red: 52.0 / 255.0, green: 169.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        
        
        // unhide remove button
        removeBtn.isHidden = false
        
        // enable second tap to zoom picture
        let zoomTap = UITapGestureRecognizer(target: self, action: #selector(zoomImg))
        zoomTap.numberOfTapsRequired = 1
        pcImg.isUserInteractionEnabled = true
        pcImg.addGestureRecognizer(zoomTap)
    }
    
    // clicked remove button
    @IBAction func removeBtn_clicked(_ sender: AnyObject) {
        self.viewDidLoad()
    }
    
    @IBAction func saveBtn_sclicked(_ sender: AnyObject) {
        // Get currect date and time
        let date = Date()
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.year, from: date as Date)
        let day = calendar.component(.year, from: date as Date)
        let hours = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        let dateComponents = NSDateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hours
        dateComponents.minute = minutes
        dateComponents.second = seconds
        
        // dismiss keyboard
        self.view.endEditing(true)
        
        // send data to server
        let object = PFObject(className: "posts")
        object["username"] = PFUser.current()?.username
        object["ava"] = PFUser.current()?.value(forKey: "ava") as! PFFile
        object["tripName"] = tripNameTxt.text
        object["gender"] = PFUser.current()?.value(forKey: "gender") as! String
        object["isPublished"] = false
        object["publishedAt"] = date
        object["currencyCode"] = currencyLbl.text
        object["totalSpents"] =  Double(totalSpentsLbl.text!)
        object["personsNr"] =  Int(personsNr.text!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyy"
        let datefrom = dateFormatter.date(from: dateFromLbl.text!)
        let dateTo = dateFormatter.date(from: dateToLbl.text!)
        object["tripFrom"] = datefrom
        object["tripTo"] = dateTo
        
        let uuid = UUID().uuidString
        object["uuid"] = "\(PFUser.current()?.username) \(uuid)"
        
        if titleTxt.text.isEmpty {
            object["title"] = ""
        } else {
            object["title"] = titleTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        // send pic to server after compression
        let imageData = UIImageJPEGRepresentation(pcImg.image!, 0.5)
        let imageFile = PFFile(name: "post.jpg", data: imageData!)
        object["pic"] = imageFile
        
        // STEP 3. Send #hashtag to server
        let words: [String] = titleTxt.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        // define tagged word
        for var word in words {
            
            // save #hashtag in server
            if word.hasPrefix("#") {
                
                // cut symbol
                word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                word = word.trimmingCharacters(in: CharacterSet.symbols)
                
                let hashtagObj = PFObject(className: "hashtags")
                hashtagObj["to"] = uuid
                hashtagObj["by"] = PFUser.current()?.username
                hashtagObj["hashtag"] = word.lowercased()
                hashtagObj["comment"] = titleTxt.text
                hashtagObj.saveInBackground(block: { (success: Bool, error: Error?) in
                    if error == nil {
                        if success {
                            print("hashtag \(word) is created")
                        }
                        
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            }
        }
        
        // finally save information
        object.saveInBackground (block: { (success:Bool, error: Error?) in
            if error == nil {
                
                // send notification wiht name "uploaded"
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
                
                // switch to another ViewController at 0 index of tabbar
                self.tabBarController!.selectedIndex = 0
                
                // reset everything
                self.viewDidLoad()
                
                self.titleTxt.text = ""
                self.tripNameTxt.text = ""
                
            }
        })
    }
    
    func didSelectDateRange(range: GLCalendarDateRange) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyy"
        
        dateFromLbl.text = "\(dateformatter.string(from: range.beginDate))"
        dateToLbl.text = "\(dateformatter.string(from: range.endDate))"
        
        startDate = range.beginDate
        endDate = range.endDate
    }
    
    func setSelectDateRange(range: GLCalendarDateRange) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyy"
        
        range.beginDate = dateformatter.date(from: dateFromLbl.text!)
        range.endDate = dateformatter.date(from: dateToLbl.text!)
        
        startDate = range.beginDate
        endDate = range.endDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showTimeframeVC" {
            // Select Range
            let vc = segue.destination as! TimeFrameVC
            
            vc.timeFrameDelegate = self
        }
        
    }
    
    
    @IBAction func selectDateBtn_clicked(_ sender: Any) {
        
        
    }
}
