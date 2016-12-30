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

class spentVC: UIViewController, UINavigationBarDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var spentTypeBtn: DLRadioButton!
    @IBOutlet weak var spentNavigationBar: UINavigationBar!
    
    @IBOutlet weak var spentNameTxt: UITextField!
    @IBOutlet weak var spentDatePicker: UIDatePicker!
    @IBOutlet weak var spentDateLbl: UILabel!
    @IBOutlet weak var spentAmountLbl: UILabel!
    @IBOutlet weak var spentAmountTxt: UITextField!
    @IBOutlet weak var spentCurrencyLbl: UILabel!
    @IBOutlet weak var spentfromLbl: UILabel!
    @IBOutlet weak var spentDescriptionTxtView: UITextView!
    
    // delegating user name from other views
    var username = String()
    var spentuuid = String()
    var isNew : Bool = true
    var spentobjectId = String()
    var spentname = String()
    var spentdescription = String()
    var spentcurrency : String = "CZK"
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
        
        // navigation bar
        self.spentNavigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 75)
        self.spentNavigationBar.barTintColor = UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)
        self.spentNavigationBar.isTranslucent = false
        self.spentNavigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        self.spentNavigationBar.backgroundColor = .white
        self.spentNavigationBar.tintColor = .white
        self.spentNavigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = spents_menu_str.uppercased()

        // Create left and right button for navigation item
        // new back button
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backBtn
        backBtn.tintColor = .white
        let editBtn = UIBarButtonItem(image: UIImage(named: "accept.png"), style: .plain, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = editBtn
        editBtn.tintColor = .white
       
        // Assign the navigation item to the navigation bar
        self.spentNavigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        view.frame = CGRect(x: 0, y: 75, width: width, height: height - 75)
        view.addSubview(self.spentNavigationBar)
        
        // allow constraints
        spentTypeBtn.translatesAutoresizingMaskIntoConstraints = false
        spentNameTxt.translatesAutoresizingMaskIntoConstraints = false
        spentDatePicker.translatesAutoresizingMaskIntoConstraints = false
        spentDateLbl.translatesAutoresizingMaskIntoConstraints = false
        spentAmountLbl.translatesAutoresizingMaskIntoConstraints = false
        spentAmountTxt.translatesAutoresizingMaskIntoConstraints = false
        spentCurrencyLbl.translatesAutoresizingMaskIntoConstraints = false
        spentfromLbl.translatesAutoresizingMaskIntoConstraints = false
        spentDescriptionTxtView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-85-[spentname(30)]-10-[spenttypebtn(20)]-10-[fromlbl(40)]",
            options: [],
            metrics: nil, views: ["spentname":spentNameTxt, "spenttypebtn": spentTypeBtn,"fromlbl":spentfromLbl]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[fromlbl]-10-[amountlbl]-10-[spentdescription(60)]-10-[datepicker(150)]",
            options: [],
            metrics: nil, views: ["fromlbl":spentfromLbl, "amountlbl": spentAmountLbl, "spentdescription":spentDescriptionTxtView, "datepicker":spentDatePicker]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[fromlbl]-10-[amount]-10-[spentdescription(60)]-10-[datepicker(150)]",
            options: [],
            metrics: nil, views: ["fromlbl":spentfromLbl, "amount": spentAmountTxt, "spentdescription":spentDescriptionTxtView,"datepicker":spentDatePicker]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[fromlbl]-10-[spentcurrency]-10-[spentdescription(60)]-10-[datepicker(150)]",
            options: [],
            metrics: nil, views: ["fromlbl":spentfromLbl, "spentcurrency": spentCurrencyLbl, "spentdescription":spentDescriptionTxtView, "datepicker":spentDatePicker]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[spentname]-10-|",
            options: [],
            metrics: nil, views: ["spentname":spentNameTxt]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[fromlbl]-10-|",
            options: [],
            metrics: nil, views: ["fromlbl":spentfromLbl]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[amountlbl(60)]-10-[amount(170)]-10-[spentcurrency(40)]-10-|",
            options: [],
            metrics: nil, views: ["amountlbl":spentAmountLbl, "amount":spentAmountTxt, "spentcurrency":spentCurrencyLbl]))

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
        let frameFirst = CGRect(x: self.view.frame.size.width / 2 - 131, y: 130, width: 162, height: 17);
        let firstRadioButton = createRadioButton(frame: frameFirst, title: spent_beginning_str, color: UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00))
        let frameSecond = CGRect(x: self.view.frame.size.width / 2 - 131 + 100, y: 130, width: 162, height: 17);
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
        spentCurrencyLbl.text = spentcurrency
        spentDescriptionTxtView.text = spentdescription
        if spenttype == 0 {
            spentfromLbl.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
        } else {
            spentfromLbl.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
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
        self.view.endEditing(true)
    }
    
    // go back function
    func back(sender: UIBarButtonItem) {
        //push back
        self.dismiss(animated: true, completion: nil)
    }
    
    // save spent icon is clicked
    func saveTapped (sender: UIBarButtonItem) {
        
        // check if new spent or its update
        if isNew {
            let spentObj = PFObject(className: "tripspents")
            spentObj["spentName"] = self.spentNameTxt.text!
            spentObj["spentDescription"] = self.spentDescriptionTxtView.text!
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd.MM.yyy"
            spentObj["spentDate"] = dateformatter.date(from: self.spentDateLbl.text!)!
            spentObj["spentAmount"] = (self.spentAmountTxt.text! as NSString).doubleValue
            spentObj["spentType"] = spenttype
            spentObj["spentCurrency"] = self.spentCurrencyLbl.text!
            spentObj["uuid"] = self.spentuuid
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
                        spentObj["spentAmount"] = (self.spentAmountTxt.text! as NSString).doubleValue
                        spentObj["spentType"] = self.spenttype
                        spentObj["spentCurrency"] = self.spentCurrencyLbl.text!
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
        self.dismiss(animated: true, completion: nil)

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

}
