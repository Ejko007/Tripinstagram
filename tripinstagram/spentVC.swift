//
//  spentVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog

struct Currency {
    
    var name: String
    var rate: Double
    
    init?(name: String, rate: Double) {
        self.name = name
        self.rate = rate
    }
}

class spentVC: UIViewController, UINavigationBarDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var spentTypeBtn: DLRadioButton!    
    @IBOutlet weak var spentNameTxt: UITextField!
    @IBOutlet weak var spentDatePicker: UIDatePicker!
    @IBOutlet weak var spentDateLbl: UILabel!
    @IBOutlet weak var spentAmountLbl: UILabel!
    @IBOutlet weak var spentAmountTxt: UITextField!
    @IBOutlet weak var spentCurrencyBtn: UIButton!
    @IBOutlet weak var spentfromLbl: UILabel!
    @IBOutlet weak var spentDescriptionTxtView: UITextView!
    
    var countriesInfo = [countryInfo]()
    var currencyList = [Currency]()
    
    // delegating user name from other views
    var username = String()
    var spentuuid = String()
    var isNew : Bool = true
    var spentobjectId = String()
    var spentname = String()
    var spentdescription = String()
    var spentcurrency = String()
    var spentamount = Double()
    var spentdate = Date()
    var spenttype : Int = 0
    
    // size of screen
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var pickerData: [String] = [String]()
    
    var placeholderLbl = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var isOwner = false
        if PFUser.current()?.username!.lowercased() == username.lowercased() {
            isOwner = true
        }
        
        // hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // hide datepicker tap
        let hideDatePicker = UITapGestureRecognizer(target: self, action: #selector(spentVC.tapFunction))
        spentDateLbl.isUserInteractionEnabled = true
        spentDateLbl.addGestureRecognizer(hideDatePicker)

        // Create a navigation item with a title
        self.navigationItem.title = spent_str.uppercased()

        // append accept button to the left
        let editBtn = UIBarButtonItem(image: UIImage(named: "accept.png"), style: .plain, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = editBtn
        editBtn.tintColor = .white
        
        // currency button frame setting
        spentCurrencyBtn.backgroundColor = .clear
        spentCurrencyBtn.layer.cornerRadius = 5
        spentCurrencyBtn.layer.borderWidth = 1
        spentCurrencyBtn.layer.borderColor = UIColor.gray.cgColor
        
        // allow constraints
        spentTypeBtn.translatesAutoresizingMaskIntoConstraints = false
        spentNameTxt.translatesAutoresizingMaskIntoConstraints = false
        spentDatePicker.translatesAutoresizingMaskIntoConstraints = false
        spentDateLbl.translatesAutoresizingMaskIntoConstraints = false
        spentAmountLbl.translatesAutoresizingMaskIntoConstraints = false
        spentAmountTxt.translatesAutoresizingMaskIntoConstraints = false
        spentCurrencyBtn.translatesAutoresizingMaskIntoConstraints = false
        spentfromLbl.translatesAutoresizingMaskIntoConstraints = false
        spentDescriptionTxtView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        // vertical constraints
        let navheight = (self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.size.height

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(navheight + 10)-[spentname]-10-[spenttypebtn(20)]-10-[fromlbl(40)]",
            options: [],
            metrics: nil, views: ["spentname":spentNameTxt, "spenttypebtn":spentTypeBtn, "fromlbl":spentfromLbl]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[fromlbl]-10-[amountlbl]-10-[spentdescription(60)]-10-[datepicker(150)]",
            options: [],
            metrics: nil, views: ["fromlbl":spentfromLbl, "amountlbl": spentAmountLbl, "spentdescription":spentDescriptionTxtView, "datepicker":spentDatePicker]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[fromlbl]-10-[amount]-10-[spentdescription(60)]-10-[datepicker(150)]",
            options: [],
            metrics: nil, views: ["fromlbl":spentfromLbl, "amount": spentAmountTxt, "spentdescription":spentDescriptionTxtView,"datepicker":spentDatePicker]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[fromlbl]-10-[currencylbl]-10-[spentdescription(60)]-10-[datepicker(150)]",
            options: [],
            metrics: nil, views: ["fromlbl":spentfromLbl, "currencylbl": spentCurrencyBtn, "spentdescription":spentDescriptionTxtView,"datepicker":spentDatePicker]))
        
        // horizontal constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[spentname]-10-|",
            options: [],
            metrics: nil, views: ["spentname":spentNameTxt]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[spenttype]-10-|",
            options: [],
            metrics: nil, views: ["spenttype":spentTypeBtn]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[fromlbl]-10-|",
            options: [],
            metrics: nil, views: ["fromlbl":spentfromLbl]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[amountlbl(60)]-10-[amount(170)]",
            options: [],
            metrics: nil, views: ["amountlbl":spentAmountLbl, "amount":spentAmountTxt]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[spentcurrency(40)]-10-|",
            options: [],
            metrics: nil, views: ["spentcurrency":spentCurrencyBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[spentdescription]-10-|",
            options: [],
            metrics: nil, views: ["spentdescription":spentDescriptionTxtView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[datepicker]-10-|",
            options: [],
            metrics: nil, views: ["datepicker":spentDatePicker]))
        
        // initial string for prompts
        spentAmountLbl.text = amount_str
        
        //specify placeholder for spent name field
        spentNameTxt.placeholder = spent_name_placehoder_str
        spentNameTxt.isUserInteractionEnabled = isOwner
        
        //specify spent fromdate label attributes
        spentfromLbl.layer.masksToBounds = true
        spentfromLbl.layer.cornerRadius = 10
        spentfromLbl.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
        spentfromLbl.textColor = .white
        let now = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyy"
        spentfromLbl.text = dateformatter.string(from: now)
        
        // spent description text view setting
        spentDescriptionTxtView.frame = CGRect(x: 0, y: 0, width: width - 20, height: 20)
        spentDescriptionTxtView!.layer.borderWidth = 1
        spentDescriptionTxtView!.layer.borderColor = UIColor.lightGray.cgColor
        spentDescriptionTxtView.layer.cornerRadius = 5
        spentDescriptionTxtView.clipsToBounds = true
        spentDescriptionTxtView.isUserInteractionEnabled = isOwner
        spentDescriptionTxtView.delegate = self
        
        // create placeholder label programatically
        let placeholderX : CGFloat = self.view.frame.size.width / 75
        let placeholderY : CGFloat = 0
        let placeholderWidth = spentDescriptionTxtView.bounds.width - placeholderX
        let placeholderHeight = spentDescriptionTxtView.bounds.height
        let placeholderFontSize = self.view.frame.size.width / 25
        
        placeholderLbl.frame = CGRect(x: placeholderX, y: placeholderY, width: placeholderWidth, height: placeholderHeight)
        if isOwner {
            placeholderLbl.text = enter_text_str
        } else {
            placeholderLbl.text = ""
        }
        placeholderLbl.font = UIFont(name: "HelveticaNeue", size: placeholderFontSize)
        placeholderLbl.textColor = UIColor.lightGray
        placeholderLbl.textAlignment = NSTextAlignment.left
        spentDescriptionTxtView.addSubview(placeholderLbl)
        
        // enable multiple selection for spent types
        spentTypeBtn.isMultipleSelectionEnabled = true
        spentTypeBtn.isUserInteractionEnabled = isOwner
        
        // programmatically add buttons
        // first radio button
        let frameFirst = CGRect(x: self.view.frame.size.width / 2 - 120, y: 50 + navheight, width: 162, height: 17);
        let firstRadioButton = createRadioButton(frame: frameFirst, title: spent_beginning_str, color: UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00))
        let frameSecond = CGRect(x: self.view.frame.size.width / 2 - 120 + 100, y: 50 + navheight, width: 162, height: 17);
        let secondRadioButton = createRadioButton(frame: frameSecond, title: spent_other_str, color: UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00))
        firstRadioButton.isEnabled = true
        // second radio button
        secondRadioButton.isIconOnRight = false
        if spenttype == 0 {
            firstRadioButton.isSelected = true
            secondRadioButton.isSelected = false
        } else {
            firstRadioButton.isSelected = false
            secondRadioButton.isSelected = true
        }
        secondRadioButton.contentHorizontalAlignment = .center
        firstRadioButton.contentHorizontalAlignment = .center
        firstRadioButton.otherButtons = [secondRadioButton]
        spentTypeBtn.isUserInteractionEnabled = isOwner
        firstRadioButton.isUserInteractionEnabled = isOwner
        secondRadioButton.isUserInteractionEnabled = isOwner
        
        // show edit button for current user post only
        if isOwner {
            self.navigationItem.rightBarButtonItems = [editBtn]
            editBtn.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItems = []
            editBtn.isEnabled = false
        }
        
        // spent amount field
        spentAmountTxt.isUserInteractionEnabled = isOwner
        
        // date picker hide or show
        spentDatePicker.isUserInteractionEnabled = isOwner
        spentDatePicker.isHidden = !isOwner
        spentDatePicker.isHidden = true
        
        getSpents()
    }
    
    // get data from selected spent from the spents list
    func getSpents() {

        spentNameTxt.text = spentname
        spentAmountTxt.text = String(format: "%.2f", spentamount)
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyy"
        spentfromLbl.text = dateformatter.string(from: spentdate)
        spentDatePicker.date = spentdate
        
        if isNew {
            // obtsin currency base for current user
            let currencyBase = PFUser.current()?.object(forKey: "currencyBase") as! String
            spentcurrency = currencyBase
        } else {
            spentCurrencyBtn.setTitle(spentcurrency, for: .normal)
        }
        
        spentDescriptionTxtView.text = spentdescription
        if spenttype == 0 {
            spentfromLbl.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
        } else {
            spentfromLbl.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
        }
        
        let spacing = CharacterSet.whitespacesAndNewlines
        if !spentDescriptionTxtView.text.trimmingCharacters(in: spacing).isEmpty {
            placeholderLbl.isHidden = true
            // text is not entered
        } else {
            placeholderLbl.isHidden = false
        }
    }
    
    // showing datepicker date
    private func dpShowDateChanged () {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyy"
        spentfromLbl.text = dateformatter.string(from: spentDatePicker.date)
    }
    
    // initrializing radiobuttons
    private func createRadioButton(frame : CGRect, title : String, color : UIColor) -> DLRadioButton {
        let radioButton = DLRadioButton(frame: frame)
        radioButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        radioButton.setTitle(title, for: UIControlState.normal)
        radioButton.setTitleColor(color, for: UIControlState.normal)
        radioButton.iconColor = color
        radioButton.indicatorColor = color
        radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        radioButton.addTarget(self, action: #selector(logSelectedButton), for: UIControlEvents.touchUpInside)
        self.view.addSubview(radioButton)
        
        return radioButton
    }
    
    @objc @IBAction private func logSelectedButton(radioButton : DLRadioButton) {
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                if button.titleLabel!.text! == spent_beginning_str {
                    spentfromLbl.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
                    spenttype = 0
                } else {
                    spentfromLbl.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
                    spenttype = 1
               }
                //print(String(format: "%@ is selected.\n", button.titleLabel!.text!))
            }
        } else {
            if radioButton.titleLabel!.text! == spent_beginning_str {
                spentfromLbl.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
                spenttype = 0
            } else {
                spentfromLbl.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
                spenttype = 1
            }

            print(String(format: "%@ is selected.\n", radioButton.selected()!.titleLabel!.text!))
        }
    }
    
    // datepicker will delegate values to label
    @IBAction func dpShowDateAction(_ sender: UIDatePicker) {
        dpShowDateChanged()
    }
    
    
    // hide keyboard func
    func hideKeyboardTap () {
        spentDatePicker.isHidden = true
        self.view.endEditing(true)
    }
        
    // save spent icon is clicked
    func saveTapped (sender: UIBarButtonItem) {
        
        // obtsin currency base for current user
        let currencyBase = PFUser.current()?.object(forKey: "currencyBase") as! String
        
        // check if new spent or its update
        if (self.spentNameTxt.text?.isEmpty)! {
            let okbtn = DefaultButton(title: ok_str, action: nil)
            let addMenu = PopupDialog(title: add_str, message: add_spent_name_str)
            addMenu.addButtons([okbtn])
            self.present(addMenu, animated: true, completion: nil)
        } else {
        
            if isNew {
                let spentObj = PFObject(className: "tripspents")
                spentObj["spentName"] = self.spentNameTxt.text!
                spentObj["spentDescription"] = self.spentDescriptionTxtView.text!
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "dd.MM.yyy"
                spentObj["spentDate"] = dateformatter.date(from: self.spentDateLbl.text!)!
                spentObj["spentType"] = spenttype
                spentObj["spentCurrency"] = self.spentCurrencyBtn.titleLabel?.text
                spentObj["uuid"] = self.spentuuid
                let currencyReference = self.spentCurrencyBtn.titleLabel?.text
                let currencyRate = getCurrencyRate(referenceCurrency: currencyReference!, searchCurrency: currencyBase)
                let spentAmount = (self.spentAmountTxt.text! as NSString).doubleValue
                spentObj["spentAmount"] = spentAmount
                spentObj["spentCurrencyRate"] = currencyRate
                spentObj.saveInBackground(block: { (success:Bool, error:Error?) in
                    if error == nil {
                        if success {
                        
                        } else {
                            print(error!.localizedDescription)
                        }
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            } else {
                let spentQuery = PFQuery(className: "tripspents")
                spentQuery.whereKey("uuid", equalTo: spentuuid)
                spentQuery.whereKey("objectId", equalTo: spentobjectId)
                spentQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                    if error == nil {
                        for spentObj in objects! {
                            spentObj["spentName"] = self.spentNameTxt.text!
                            spentObj["spentDescription"] = self.spentDescriptionTxtView.text!
                            let dateformatter = DateFormatter()
                            dateformatter.dateFormat = "dd.MM.yyy"
                            spentObj["spentDate"] = dateformatter.date(from: self.spentDateLbl.text!)!
                            let spentAmount = (self.spentAmountTxt.text! as NSString).doubleValue
                            spentObj["spentAmount"] = spentAmount
                            let currencyReference = self.spentCurrencyBtn.titleLabel?.text
                            let currencyRate = getCurrencyRate(referenceCurrency: currencyReference!, searchCurrency: currencyBase)
                            spentObj["spentCurrencyRate"] = currencyRate
                            spentObj["spentType"] = self.spenttype
                            spentObj["spentCurrency"] = self.spentCurrencyBtn.titleLabel?.text
                            spentObj.saveInBackground(block: { (success:Bool, error:Error?) in
                                if error == nil {
                                    if success {
                                        
                                    } else {
                                        print(error!.localizedDescription)
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
        
        //push back
        _ = navigationController?.popViewController(animated: true)
        }
    }
    
    // while writing something
    func textViewDidChange(_ textView: UITextView) {
        
        // disable button if entered no text
        let spacing = CharacterSet.whitespacesAndNewlines
        
        // entered text
        if !spentDescriptionTxtView.text.trimmingCharacters(in: spacing).isEmpty {
            placeholderLbl.isHidden = true
            // text is not entered
        } else {
            placeholderLbl.isHidden = false
        }
    }
    
    func tapFunction(sender:UITapGestureRecognizer) {
        spentDatePicker.isHidden = !spentDatePicker.isHidden
        self.view.endEditing(true)
    }
    
    
    @IBAction func spentCurrencyBtn_tapped(_ sender: UIButton) {
        let popoverContent = self.storyboard?.instantiateViewController(withIdentifier: "currenciesTVC") as! currenciesTVC
        
        popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
        if let popover = popoverContent.popoverPresentationController {
            popoverContent.preferredContentSize = CGSize(width: 250, height: 450)
            
            popoverContent.popoverPresentationController!.delegate = self
            popoverContent.delegate = self
            
            popover.delegate = self
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }
        
        self.present(popoverContent, animated: true, completion: nil)
    }
}

// popoverDelegate procedure for currencies view field
extension spentVC: CurrenciesPopoverDelegate {
    func updateCurrencyCode(withCountries countries: [countryInfo]) {
        self.countriesInfo.removeAll(keepingCapacity: false)
        self.countriesInfo = countries
        
        var currenciesArray = [String]()
        var countItems = Int()
        var flagsCodes = [String]()
        
        flagsCodes.removeAll(keepingCapacity: false)
        currenciesArray.removeAll(keepingCapacity: false)
        
        if countries.count != 0 {
            
            for i in 0...countries.count - 1 {
                flagsCodes.append(countries[i].name)
            }
            
            countItems = flagsCodes.count
            
            for j in 0...countItems - 1 {
                let currencyCode = IsoCountryCodes.searchByName(name: flagsCodes[j]).currency
                currenciesArray.append(currencyCode)
            }
            
            spentCurrencyBtn.setTitle(currenciesArray.last!, for: .normal)
            currencyList = getCurrencyList(referenceCurrency: currenciesArray.last!)
        }
    }
}

// MARK: UIPopoverPresentationControllerDelegate
extension spentVC: UIPopoverPresentationControllerDelegate {
    
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


