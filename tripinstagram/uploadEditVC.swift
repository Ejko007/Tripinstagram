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
    
    var removePicture:Bool = false
    
    var quantity = 1
    
    var countriesInfo = [countryInfo]()
    
    // arrays to hold information from server
    var dateFromArray = [Date?]()
    var dateToArray = [Date?]()
    var picArray = [PFFile]()
    var uuidArray = [String]()
    var personsNrArray = [Int]()
    var currencyArray = [String]()
    var titleTxtArray = [String]()
    var levelArray = [Int]()
    var publishArray = [Bool]()

    var countriesArray = Array<Array<String>>()
    
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
    
    //let pictureWidth = width - 20
    let pictureWidth = UIScreen.main.bounds.width / 2

    override func viewDidLoad() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height

        var countries = [String]()
        
        super.viewDidLoad()
        
        // title label at the top
        self.navigationItem.title = update_post_str.uppercased()
        
        // create accept icon to save post
        saveBtn.isEnabled = true
        saveBtn.titleLabel!.text = save_str
        saveBtn.isHidden = false

        // set save button position
        var btnshift:CGFloat = 0
        if removePicture {
            btnshift = 0
            saveBtn.backgroundColor = UIColor.lightGray
        } else {
            saveBtn.backgroundColor = UIColor(red: 52.0 / 255.0, green: 169.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
            btnshift = 1
        }
        
        let tabbarHeight = self.tabBarController?.tabBar.frame.size.height
        self.saveBtn.frame = CGRect(x: 0, y: height - btnshift * tabbarHeight! - width / 8, width: width, height: width / 8)
        self.publishLbl.frame = CGRect(x: 15, y: height - btnshift * tabbarHeight! - width / 8 - 35, width: width / 2, height: 20)
        self.publishSwitch.frame = CGRect(x: width / 2 + 100, y: height - btnshift * tabbarHeight! - width / 8 - 40, width: width / 2 - 100, height: 20)
        self.publishSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)

        if !removePicture {
            // show remove button
            removeBtn.isHidden = false
        } else {
            // hide remove button
            removeBtn.isHidden = true
            // standard UI containt
            pcImg.image = UIImage(named: "pbg.png")
        }
        
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
        
        // set clear background color
        countriesView.backgroundColor = .clear
        
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
                self.personsNrArray.removeAll(keepingCapacity: false)
                self.currencyArray.removeAll(keepingCapacity: false)
                self.titleTxtArray.removeAll(keepingCapacity: false)
                self.levelArray.removeAll(keepingCapacity: false)
                countries.removeAll(keepingCapacity: false)
                self.countriesArray.removeAll(keepingCapacity: false)
                self.publishArray.removeAll(keepingCapacity: false)
               
                //find related objects
                for object in objects! {
                    self.dateFromArray.append((object.value(forKey: "tripFrom") as! Date))
                    self.dateToArray.append((object.value(forKey: "tripTo") as! Date))
                    self.picArray.append(object.value(forKey: "pic") as! PFFile)
                    self.uuidArray.append(object.value(forKey: "uuid") as! String)
                    self.personsNrArray.append(object.value(forKey: "personsNr") as! Int)
                    self.currencyArray.append(object.value(forKey: "currencyCode") as! String)
                    self.titleTxtArray.append(object.value(forKey: "title") as! String)
                    self.levelArray.append(object.value(forKey: "level") as! Int)
                    countries.removeAll(keepingCapacity: false)
                    countries = object.object(forKey: "countries") as! [String]
                    self.countriesArray.append(countries)
                    self.publishArray.append(object.value(forKey: "isPublished") as! Bool)
                 }
                
                // place post picture
                self.picArray.last?.getDataInBackground(block: { (data: Data?, error: Error?) in
                    if error == nil {
                        if self.removePicture {
                            self.pcImg.image = UIImage(named: "pbg.png")
                         } else {
                            self.pcImg.image = UIImage(data: data!)
                        }
                    } else {
                        print (error!.localizedDescription)
                    }
                })
                
                self.publishLbl.text = publish_str
                self.titleTxt.text = self.titleTxtArray.last
                self.personsNr.text = "\(self.personsNrArray.last!)"
                self.levelNr.text = "\(self.levelArray.last!)"
                self.publishSwitch.isOn = self.publishArray.last!
                
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "dd.MM.yyy"
                self.dateFromLbl.text = dateformatter.string(from: (self.dateFromArray.last!)!)
                self.dateToLbl.text = dateformatter.string(from: (self.dateToArray.last!)!)
                
                self.startDate = GLDateUtils.date(byAddingDays: 0, to: (self.dateFromArray.last!)!) as Date
                self.endDate = GLDateUtils.date(byAddingDays: 0, to: (self.dateToArray.last!)!) as Date
                
                // place countries flags
                var flagsImageArray = [UIImage]()
                var countItems = Int()
                var flagsCodes = [String]()
                var subview = UIImageView()
                let maxImgCount = 7
                
                flagsCodes.removeAll(keepingCapacity: false)
                flagsImageArray.removeAll(keepingCapacity: false)
                
                // remove all subviews
                for view in self.countriesView.subviews {
                    view.removeFromSuperview()
                }
                
                if countries.count != 0 {
                    
                    for i in 0...countries.count - 1 {
                        flagsCodes.append(countries[i])
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
                        self.countriesView.addSubview(subview)
                        count += 1
                    }
                }
                
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
                self.selectDateBtn.isHidden = false
                
                self.removeBtn.isHidden = false
            })
        }
    }
    
    // fields alignement function
    func alignement () {
        let width = self.view.frame.size.width
        
        let navheight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.size.height
        
        pcImg.frame = CGRect(x: 15, y: navheight + 15, width: pictureWidth, height: pictureWidth)
        
        titleTxt.frame = CGRect(x: 15, y: navheight + pcImg.frame.size.height + 15 + 30, width:
            width - 30, height: pcImg.frame.size.height)
        
        countriesView.frame = CGRect(x: width - 40, y: navheight + 15, width:
            30, height: 20)
        
        dateFromLbl.frame = CGRect(x: 30 + pictureWidth, y: navheight + 15, width:
            70, height: 15)
        
        selectDateBtn.frame = CGRect(x: 30 + pictureWidth, y: dateFromLbl.frame.origin.y + 20, width: 30, height: 30)
        
        dateToLbl.frame = CGRect(x: 30 + pictureWidth, y: selectDateBtn.frame.origin.y + 35, width:
            70, height: 15)
        
        countryIconBtn.frame = CGRect(x: 30 + pictureWidth, y: navheight + 10 + pictureWidth / 2, width: 25, height: 25)
        
        personsNrImg.frame = CGRect(x: 30 + pictureWidth, y: navheight + 40 + pictureWidth / 2, width: 25, height: 25)
        
        personsNr.frame = CGRect(x: 80 + pictureWidth, y: navheight + 40 + pictureWidth / 2, width: 30, height: 30)
        
        levelBtnImg.frame = CGRect(x: 30 + pictureWidth, y: navheight + 15 + pcImg.frame.height - 25, width: 25, height: 25)
        levelBtnImg.layer.cornerRadius = 5
        levelBtnImg.clipsToBounds = true
        
        levelNr.frame = CGRect(x: 80 + pictureWidth, y: navheight + 15 + pcImg.frame.height - 30, width: 30, height: 30)
        
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
        removePicture = true
        self.viewDidLoad()
    }
    
    @IBAction func saveBtn_clicked(_ sender: AnyObject) {
        
        // get udpated object from the server
        let postQuery = PFQuery(className: "posts")
        postQuery.whereKey("uuid", equalTo: postuuid.last!)
        postQuery.findObjectsInBackground (block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                for object in objects! {
                    object["username"] = PFUser.current()?.username
                    object["ava"] = PFUser.current()?.value(forKey: "ava") as! PFFile
                    object["gender"] = PFUser.current()?.value(forKey: "gender") as! String
                    object["personsNr"] =  Int(self.personsNr.text!)
                    object["level"] =  Int(self.levelNr.text!)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyy"
                    let datefrom = dateFormatter.date(from: self.dateFromLbl.text!)
                    let dateTo = dateFormatter.date(from: self.dateToLbl.text!)
                    object["tripFrom"] = datefrom
                    object["tripTo"] = dateTo
                    if self.titleTxt.text.isEmpty {
                        object["title"] = ""
                    } else {
                        object["title"] = self.titleTxt.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    }
                    object["isPublished"] = self.publishSwitch.isOn
                    
                    // send pic to server after compression
                    let imageData = UIImageJPEGRepresentation(self.pcImg.image!, 0.5)
                    let imageFile = PFFile(name: "post.jpg", data: imageData!)
                    object["pic"] = imageFile
                    
                    // find and delete #hashtags for this post first
                    let hashtagQuery = PFQuery(className: "hashtags")
                    hashtagQuery.whereKey("to", equalTo: postuuid.last!)
                    hashtagQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                        if error == nil {
                            for object in objects! {
                                object.deleteEventually()
                            }
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                    
                    // send #hashtag to server
                    let words: [String] = self.titleTxt.text!.components(separatedBy: CharacterSet.whitespacesAndNewlines)
                    
                    // define tagged word
                    for var word in words {
                        
                        // save #hashtag in server
                        if word.hasPrefix("#") {
                            
                            // cut symbol
                            word = word.trimmingCharacters(in: CharacterSet.punctuationCharacters)
                            word = word.trimmingCharacters(in: CharacterSet.symbols)
                            
                            let hashtagObj = PFObject(className: "hashtags")
                            hashtagObj["to"] = postuuid.last!
                            hashtagObj["by"] = PFUser.current()?.username
                            hashtagObj["hashtag"] = word.lowercased()
                            hashtagObj["comment"] = self.titleTxt.text
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
                    
                    // update object on the server
                    object.saveInBackground (block: { (success:Bool, error: Error?) in
                        if error == nil {
                            // dismiss view controller and move to firts tab
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                            self.navigationController?.popViewController(animated: true)
                                                        
                            // reset everything
                            self.viewDidLoad()
                            
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                }
                
                // dismiss keyboard
                self.view.endEditing(true)
                
            } else {
                print(error!.localizedDescription)
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
    
    func setSelectDateRange(range: GLCalendarDateRange) {
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
                // vc.timeFrame?.beginDate = Date()
                // vc.timeFrame?.endDate = Date()
                vc.timeFrameDelegate = self
            case "showCountries":
                // let embeddedPPC = segue.destination.popoverPresentationController
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
extension uploadEditVC: QuantityPersonsPopoverDelegate {
    func updatePersonsNr(withQuantity quantity: Int) {
        self.quantity = quantity
        self.personsNr.text = "\(self.quantity)"
    }
}

// quantityPopoverDelegate procedure for levelsNr field
extension uploadEditVC: QuantityLevelsPopoverDelegate {
    func updateLevelsNr(withQuantity quantity: Int) {
        self.quantity = quantity
        self.levelNr.text = "\(self.quantity)"
    }
}

// popoverDelegate procedure for countries view field
extension uploadEditVC: CountriesPopoverDelegate {
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
extension uploadEditVC: UIPopoverPresentationControllerDelegate {
    
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
