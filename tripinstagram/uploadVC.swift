//
//  uploadVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TimeFrameDelegate {
    
    var startDate:Date?
    var endDate:Date?

    @IBOutlet weak var pcImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var dateFromLbl: UILabel!
    @IBOutlet weak var dateToLbl: UILabel!
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var personsNrImg: UIButton!
    @IBOutlet weak var personsNr: UILabel!
    @IBOutlet weak var levelBtnImg: UIButton!
    @IBOutlet weak var levelNr: UILabel!
    
    let pictureWidth = UIScreen.main.bounds.width / 2
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // title label at the top
        self.navigationItem.title = new_feed_str.uppercased()
        
        // disable save btn by default
        saveBtn.isEnabled = false
        saveBtn.backgroundColor = .lightGray
        saveBtn.titleLabel!.text = save_str
        
        // hide remove button
        removeBtn.isHidden = true
                
        // standard UI containt
        pcImg.image = UIImage(named: "pbg.png")
        titleTxt.text = ""
        
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
        
        // set default fromDate and endDate labels
        let today = Date()
        startDate = GLDateUtils.date(byAddingDays: 0, to: today as Date)
        endDate = GLDateUtils.date(byAddingDays: 7, to: today as Date)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyy"
        dateFromLbl.text = dateformatter.string(from: startDate!)
        dateToLbl.text = dateformatter.string(from: endDate!)
        
        // set initial level
        levelNr.text = "0"
        
        // set initial number of persons
        personsNr.text = "2"
        
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
        let navheight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.size.height
        let tabbarheight = (self.tabBarController?.tabBar.frame.height)!
        let picspace = self.view.frame.size.height - navheight - tabbarheight
        let picshift = picspace / 2 - pictureWidth / 2 - 40
        
        // define frame of zoomed image
        let zoomed = CGRect(x: 0, y: navheight + picshift, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        // frame of unzoomed (small) image
        //let unzoomed = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
        let unzoomed = CGRect(x: 15, y: navheight + 15, width: pictureWidth, height: pictureWidth)
      
        // id picture is unzoomed, zoom it
        if pcImg.frame == unzoomed {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.pcImg.frame = zoomed
                
                // hide objects from background
                self.view.backgroundColor = .black
                self.titleTxt.alpha = 0
                self.saveBtn.alpha = 0
                self.personsNr.alpha = 0
                self.personsNrImg.alpha = 0
                self.dateFromLbl.alpha = 0
                self.dateToLbl.alpha = 0
                self.levelBtnImg.alpha = 0
                self.levelNr.alpha = 0
                self.selectDateBtn.isHidden = true
               
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
                self.personsNr.alpha = 1
                self.personsNrImg.alpha = 1
                self.dateFromLbl.alpha = 1
                self.dateToLbl.alpha = 1
                self.levelBtnImg.alpha = 1
                self.levelNr.alpha = 1
                self.selectDateBtn.isHidden = false
                
                self.removeBtn.isHidden = false
            })
        }
    }
    
    // fields alignement function
    func alignement () {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        let navheight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.size.height
        
        pcImg.frame = CGRect(x: 15, y: navheight + 15, width: pictureWidth, height: pictureWidth)
        
        titleTxt.frame = CGRect(x: 15, y: navheight + pcImg.frame.size.height + 15 + 30, width:
            width - 30, height: pcImg.frame.size.height)
        
        dateFromLbl.frame = CGRect(x: 30 + pictureWidth, y: navheight + 15, width:
            70, height: 15)
        
        selectDateBtn.frame = CGRect(x: 30 + pictureWidth, y: dateFromLbl.frame.origin.y + 20, width: 30, height: 30)
        
        dateToLbl.frame = CGRect(x: 30 + pictureWidth, y: selectDateBtn.frame.origin.y + 35, width:
            70, height: 15)
        
        personsNrImg.frame = CGRect(x: 30 + pictureWidth, y: navheight + 35 + pictureWidth / 2, width: 25, height: 25)
        
        personsNr.frame = CGRect(x: 80 + pictureWidth, y: navheight + 35 + pictureWidth / 2, width: 30, height: 30)

        levelBtnImg.frame = CGRect(x: 30 + pictureWidth, y: navheight + 15 + pcImg.frame.height - 25, width: 25, height: 25)
        levelBtnImg.layer.cornerRadius = 5
        levelBtnImg.clipsToBounds = true
        
        levelNr.frame = CGRect(x: 80 + pictureWidth, y: navheight + 15 + pcImg.frame.height - 30, width: 30, height: 30)

        saveBtn.frame = CGRect(x: 0, y: height - width / 8, width: width, height: width / 8)
        
        removeBtn.frame = CGRect(x: pcImg.frame.origin.x, y: navheight + 10 + pcImg.frame.size.height + 10, width: pcImg.frame.size.width, height: 20)
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
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.year, from: date as Date)
        let day = calendar.component(.year, from: date as Date)
        let hours = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        let seconds = calendar.component(.second, from: date as Date)
        var dateComponents = DateComponents()
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
        object["gender"] = PFUser.current()?.value(forKey: "gender") as! String
        object["isPublished"] = false
        object["level"] = Int(levelNr.text!)
        object["totalDistance"] = 0
        object["publishedAt"] = date
        object["currencyCode"] = "CZK"
        object["totalSpents"] =  Double("0.00")
        object["countries"] = [""]
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
            }
        })
    }
    
    func didSelectDateRange(_ range: GLCalendarDateRange) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyy"
        
        dateFromLbl.text = "\(dateformatter.string(from: range.beginDate))"
        dateToLbl.text = "\(dateformatter.string(from: range.endDate))"
        
        startDate = range.beginDate
        endDate = range.endDate        
    }

    func setSelectDateRange(_ range: GLCalendarDateRange) {
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
