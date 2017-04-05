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
    
    var removePicture:Bool = true

    var quantity = 1
    
    var countriesInfo = [countryInfo]()

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
    @IBOutlet weak var countryIconBtn: UIButton!
    @IBOutlet weak var countriesView: UIView!
    @IBOutlet weak var publishLbl: UILabel!
    @IBOutlet weak var publishSwitch: UISwitch!
    
    let pictureWidth = UIScreen.main.bounds.width / 2
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // title label at the top
        self.navigationItem.title = new_feed_str.uppercased()
        
        // disable save btn by default
        saveBtn.isEnabled = false
        saveBtn.backgroundColor = .lightGray
        saveBtn.titleLabel!.text = save_str
        self.publishLbl.text = publish_str
        
        // hide remove button
        if !removePicture {
            // show remove button
            removeBtn.isHidden = false
        } else {
            // hide remove button
            removeBtn.isHidden = true
            // standard UI containt
            pcImg.image = UIImage(named: "pbg.png")
        }
        
        // standard UI containt
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
        personsNr.text = "1"
        
        // set clear background color
        countriesView.backgroundColor = .clear
        
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
                self.publishLbl.alpha = 0
                self.publishSwitch.alpha = 0
                self.countryIconBtn.alpha = 0
                self.countriesView.alpha = 0
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
                self.publishLbl.alpha = 1
                self.publishSwitch.alpha = 1
                self.countriesView.alpha = 1
                self.countryIconBtn.alpha = 1
                self.selectDateBtn.isHidden = false
                
                // show remove button
                self.removeBtn.isHidden = false
            })
        }
    }
    
    // fields alignement function
    func alignement () {
        
        let width = self.view.frame.size.width
        
        let navheight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.size.height
                
        pcImg.translatesAutoresizingMaskIntoConstraints = false
        titleTxt.translatesAutoresizingMaskIntoConstraints = false
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        dateFromLbl.translatesAutoresizingMaskIntoConstraints = false
        dateToLbl.translatesAutoresizingMaskIntoConstraints = false
        selectDateBtn.translatesAutoresizingMaskIntoConstraints = false
        personsNrImg.translatesAutoresizingMaskIntoConstraints = false
        personsNr.translatesAutoresizingMaskIntoConstraints = false
        levelBtnImg.translatesAutoresizingMaskIntoConstraints = false
        levelNr.translatesAutoresizingMaskIntoConstraints = false
        countryIconBtn.translatesAutoresizingMaskIntoConstraints = false
        countriesView.translatesAutoresizingMaskIntoConstraints = false
        publishLbl.translatesAutoresizingMaskIntoConstraints = false
        publishSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        publishSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)

        levelBtnImg.layer.cornerRadius = 5
        levelBtnImg.clipsToBounds = true

        // constraints
        // vertical constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(navheight + 15)-[picture(\(pictureWidth))]-10-[removebtn(20)]-10-[titletxt(\(pictureWidth))]",
            options: [],
            metrics: nil, views: ["picture":pcImg, "removebtn":removeBtn, "titletxt":titleTxt]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[publishlbl(20)]-15-[savebtn(\(width / 8))]-|",
            options: [],
            metrics: nil, views: ["publishlbl":publishLbl, "savebtn":saveBtn]))
       
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[publishswitch(20)]-15-[savebtn(\(width / 8))]-|",
            options: [],
            metrics: nil, views: ["publishswitch":publishSwitch, "savebtn":saveBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(navheight + 15)-[datefromlbl]-5-[calendarbtn(20)]-5-[dateto]-5-[countriesbtn(30)]-5-[personsbtn(30)]-5-[levelbtn(30)]-40-[titletxt]",
            options: [],
            metrics: nil, views: ["datefromlbl":dateFromLbl, "calendarbtn":selectDateBtn, "dateto":dateToLbl, "countriesbtn":countryIconBtn, "personsbtn":personsNrImg, "levelbtn":levelBtnImg, "titletxt":titleTxt]))
       
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(navheight + 15)-[datefromlbl]-5-[calendarbtn]-5-[dateto]-40-[personsnr(30)]-5-[levelsnr(30)]-40-[titletxt]",
            options: [],
            metrics: nil, views: ["datefromlbl":dateFromLbl, "calendarbtn":selectDateBtn, "dateto":dateToLbl, "personsnr":personsNr, "levelsnr":levelNr, "titletxt":titleTxt]))
       
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(navheight + 15)-[countriesview(20)]",
            options: [],
            metrics: nil, views: ["countriesview":countriesView]))
       
        // horizontal constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[picture(\(pictureWidth))]-15-[datefrom]-[countriesview(30)]-15-|",
            options: [],
            metrics: nil, views: ["picture":pcImg, "datefrom":dateFromLbl, "countriesview":countriesView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[picture(\(pictureWidth))]-15-[calendaricon(20)]",
            options: [],
            metrics: nil, views: ["picture":pcImg, "calendaricon":selectDateBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[picture(\(pictureWidth))]-15-[dateto]",
            options: [],
            metrics: nil, views: ["picture":pcImg, "dateto":dateToLbl]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[picture(\(pictureWidth))]-15-[countriesbtn(30)]",
            options: [],
            metrics: nil, views: ["picture":pcImg, "countriesbtn":countryIconBtn]))
 
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[picture(\(pictureWidth))]-15-[personsbtn(30)]-15-[personsnr]",
            options: [],
            metrics: nil, views: ["picture":pcImg, "personsbtn":personsNrImg, "personsnr":personsNr]))
       
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[picture(\(pictureWidth))]-15-[levelbtn(30)]-15-[levelnr]",
            options: [],
            metrics: nil, views: ["picture":pcImg, "levelbtn":levelBtnImg, "levelnr":levelNr]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[removebtn]",
            options: [],
            metrics: nil, views: ["removebtn":removeBtn]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[titletxt]-15-|",
            options: [],
            metrics: nil, views: ["titletxt":titleTxt]))
       
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[publishlbl]-[publishswitch]-15-|",
            options: [],
            metrics: nil, views: ["publishlbl":publishLbl, "publishswitch":publishSwitch]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[savebtn]-0-|",
            options: [],
            metrics: nil, views: ["savebtn":saveBtn]))
        
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
        removePicture = true
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
        object["isPublished"] = publishSwitch.isOn
        object["totalDistance"] = 0
        object["publishedAt"] = date
        object["currencyCode"] = "CZK"
        object["totalSpents"] =  Double("0.00")
        object["personsNr"] =  Int(personsNr.text!)
        object["level"] =  Int(levelNr.text!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyy"
        let datefrom = dateFormatter.date(from: dateFromLbl.text!)
        let dateTo = dateFormatter.date(from: dateToLbl.text!)
        object["tripFrom"] = datefrom
        object["tripTo"] = dateTo
        var countries = [String]()
        if !countriesInfo.isEmpty {
            for i in 0...self.countriesInfo.count - 1 {
                countries.append(self.countriesInfo[i].name)
            }
            object["countries"] = countries
        } else {
            object["countries"] = [""]
        }
        
        let uuid = UUID().uuidString
        object["uuid"] = "\(String(describing: PFUser.current()?.username)) \(uuid)"
        
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
                self.publishSwitch.isOn = false
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
        
        if let identifier = segue.identifier {
            switch identifier {
            case "showTimeframeVC":
                let vc = segue.destination as! TimeFrameVC
                vc.timeFrameDelegate = self
            case "showCountries":
                let embeddedPPC = segue.destination as! countriesTVC
                embeddedPPC.delegate = self
            case "seguePersonsNr":
                let quantityVC = segue.destination as! quantityTVC
                quantityVC.modalPresentationStyle = UIModalPresentationStyle.popover
                quantityVC.popoverPresentationController!.delegate = self
                quantityVC.delegate = self
            default:
                break
            }
        }
        
    }
    
    
    @IBAction func selectDateBtn_clicked(_ sender: Any) {
    
    
    }
    
    @IBAction func personsNrBtn_tapped(_ sender: UIButton) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "quantityTVC") as! quantityTVC
        
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popover = popoverContent.popoverPresentationController {
            popoverContent.preferredContentSize = CGSize(width: 70, height: 450)
            
            popoverContent.popoverPresentationController!.delegate = self
            popoverContent.delegate = self

            popover.delegate = self
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
    
    @IBAction func countryIconBtn_tapped(_ sender: UIButton) {
//        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "countriesTVC") as! countriesTVC
//        
//        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
//        if let popover = popoverContent.popoverPresentationController {
//            popoverContent.preferredContentSize = CGSize(width: 270, height: 450)
//            
//            popoverContent.popoverPresentationController!.delegate = self
//            // popoverContent.delegate = self
//            
//            popover.delegate = self
//            popover.sourceView = sender
//            popover.sourceRect = sender.bounds
//        }
//        
//        self.present(popoverContent, animated: true, completion: nil)
    }
    
    @IBAction func levelsNrBtn_tapped(_ sender: UIButton) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "quantityLevelTVC") as! quantityLevelTVC
        
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popover = popoverContent.popoverPresentationController {
            popoverContent.preferredContentSize = CGSize(width: 70, height: 450)
            
            popoverContent.popoverPresentationController!.delegate = self
            popoverContent.delegate = self
            
            popover.delegate = self
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
        
        self.present(popoverContent, animated: true, completion: nil)
    }
    
}

// quantityPopoverDelegate procedure for personsNr field
extension uploadVC: QuantityPersonsPopoverDelegate {
    func updatePersonsNr(withQuantity quantity: Int) {
        self.quantity = quantity
        self.personsNr.text = "\(self.quantity)"
    }
}

// quantityPopoverDelegate procedure for levelsNr field
extension uploadVC: QuantityLevelsPopoverDelegate {
    func updateLevelsNr(withQuantity quantity: Int) {
        self.quantity = quantity
        self.levelNr.text = "\(self.quantity)"
    }
}

// popoverDelegate procedure for countries view field
extension uploadVC: CountriesPopoverDelegate {
    func updateCountriesFlags(withCountries countries: [countryInfo]) {
        self.countriesInfo.removeAll(keepingCapacity: false)
        self.countriesInfo = countries
        
        var flagsImageArray = [UIImage]()
        var countItems = Int()
        var flagsCodes = [String]()
        var subview = UIImageView()
        let maxImgCount = 7

        flagsCodes.removeAll(keepingCapacity: false)
        flagsImageArray.removeAll(keepingCapacity: false)
        
        // remove all subviews
        for view in countriesView.subviews {
            view.removeFromSuperview()
        }

        if countries.count != 0 {
            
            for i in 0...countries.count - 1 {
                flagsCodes.append(countries[i].name)
            }
            
            countItems = flagsCodes.count
            if countItems > maxImgCount {
                countItems = maxImgCount
            }
            
            for j in 0...countItems - 1 {
                if let flagImage = UIImage(named: IsoCountryCodes.searchByName(name: flagsCodes[j]).alpha2) {
                    flagsImageArray.append(flagImage)
                } else {
                    flagsImageArray.append(UIImage(named: "WW")!)
                }
            }
            
            var count = 0
            for i in 0...countItems - 1 {
                //Add a subview at the position
                subview = UIImageView(frame: CGRect(x: 0 , y: 20 * CGFloat(i), width: 30, height: 20))
                subview.image = flagsImageArray[count]
                //self.view.addSubview(subview)
                countriesView.addSubview(subview)
                count += 1
            }
        }
    }
}

// MARK: UIPopoverPresentationControllerDelegate
extension uploadVC: UIPopoverPresentationControllerDelegate {
    
    // In modal presentation we need to add a button to our popover
    // to allow it to be dismissed. Handle the situation where
    // our popover may be embedded in a navigation controller
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        guard style != .none else {
            return controller.presentedViewController
        }
        
        if let navController = controller.presentedViewController as? UINavigationController {
            addDismissButton(navigationController: navController)
            return navController
        } else {
            let navController = UINavigationController.init(rootViewController: controller.presentedViewController)
            addDismissButton(navigationController: navController)
            return navController
        }
    }
    
    // Check for when we present in a non modal style and remove the
    // the dismiss button from the navigation bar.
    
    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        if style == .none {
            if let navController = presentationController.presentedViewController as? UINavigationController {
                removeDismissButton(navigationController: navController)
            }
        }
    }
    
    func didDismissPresentedView() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func addDismissButton(navigationController: UINavigationController) {
        let rootViewController = navigationController.viewControllers[0]
        rootViewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done,
        target: self, action: #selector(didDismissPresentedView))
    }
    
    private func removeDismissButton(navigationController: UINavigationController) {
        let rootViewController = navigationController.viewControllers[0]
        rootViewController.navigationItem.leftBarButtonItem = nil
    }
}
