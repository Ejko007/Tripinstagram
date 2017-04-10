//
//  editVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog

class editVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //UI objects
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var telTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    @IBOutlet weak var currencyUsedBtn: UIButton!
    @IBOutlet weak var currencyUsedTxt: UITextField!
    
    // pickerView & pickerData
    var genderPicker = UIPickerView()
    let genders = [male_str, female_str]
    
    // keyboard to hold frame size
    var keyboard = CGRect()
    
    var countriesInfo = [countryInfo]()
    var currencyList = [Currency]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // create picker
        genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackground
        genderPicker.showsSelectionIndicator = true
        genderTxt.inputView = genderPicker
        
        // check notification of keyboard - to show or not
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // tap to choose image
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(loadImg(recognizer:)))
        avaTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(avaTap)
        
        // call information function
        information()
        
        // call alignement function
        alignement()

    }
    
    // func when keyboard is shown
    func keyboardWillShow (notification: NSNotification) {
        
        // define keyboard frame size
        keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!

        
        // move up with animation
        UIView.animate(withDuration: 0.4) { 
            self.scrollView.contentSize.height = self.view.frame.size.height + self.keyboard.height / 2
        }
    }
    
    // func when keyboard is hidden
    func keyboardWillHide (notification: NSNotification) {
        
        // move down with animation
        UIView.animate(withDuration: 0.4) { 
            self.scrollView.contentSize.height = 0
        }
    }
    
    // func to hide keyboard
    func hideKeyboard () {
        self.view.endEditing(true)
    }
    
    // func to call UIImagePickerController
    func loadImg (recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // method to finalize our actions with UIImagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    // alignement function
    func alignement () {
       
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        avaImg.frame = CGRect(x: width - 68 - 10, y: 15, width: 68, height: 68)
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        fullnameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y, width: width - avaImg.frame.size.width - 30, height: 30)
        usernameTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: width - avaImg.frame.size.width - 30, height: 30)
        webTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: width - 20, height: 30)
        
        bioTxt.frame = CGRect(x: 10, y: webTxt.frame.origin.y + 40, width: width - 20, height: 60)
        bioTxt.layer.borderWidth = 1
        bioTxt.layer.borderColor = UIColor(red: 230 / 255.5, green: 230 / 255.5, blue: 230 / 255.5, alpha: 1).cgColor
        bioTxt.layer.cornerRadius = bioTxt.frame.size.width / 50
        bioTxt.clipsToBounds = true
        
        
        emailTxt.frame = CGRect(x: 10, y: bioTxt.frame.origin.y + 100, width: width - 20, height: 30)
        telTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: width - 20, height: 30)
        titleLbl.frame = CGRect(x: 15, y: emailTxt.frame.origin.y - 30, width: width - 20, height: 30)
        genderTxt.frame = CGRect(x: 10, y: telTxt.frame.origin.y + 40, width: width - 20, height: 30)

        currencyUsedTxt.frame = CGRect(x: 10, y: genderTxt.frame.origin.y + 40, width: width - 70, height: 30)
        currencyUsedTxt.text = currency_used_str
        currencyUsedTxt.isEnabled = false
        currencyUsedBtn.frame = CGRect(x: width - 50, y: genderTxt.frame.origin.y + 40, width: 40, height: 30)
        currencyUsedBtn.backgroundColor = .clear
        currencyUsedBtn.layer.cornerRadius = 5
        currencyUsedBtn.layer.borderWidth = 1
        currencyUsedBtn.layer.borderColor = UIColor.gray.cgColor
    }
    
    // PickerView methods
    // picker number of components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // picker text number
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    // picker text config
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    // picker did selected some value from it
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxt.text = genders[row]
        self.view.endEditing(true)
    }
    
    
    // user information function
    func information () {
        
        // receive profile image
        let ava = PFUser.current()?.object(forKey: "ava") as! PFFile
        ava.getDataInBackground (block: { (data:Data?, error:Error?) in
            if error == nil {
            self.avaImg.image = UIImage(data: data!)
        
            // receive text information
            self.usernameTxt.text = PFUser.current()?.username
            self.fullnameTxt.text = PFUser.current()?.object(forKey: "fullname") as? String
            self.bioTxt.text = PFUser.current()?.object(forKey: "bio") as? String
            self.webTxt.text = PFUser.current()?.object(forKey: "web") as? String
            self.emailTxt.text = PFUser.current()?.email
            self.telTxt.text = PFUser.current()?.object(forKey: "tel") as? String
            self.currencyUsedBtn.titleLabel?.text = PFUser.current()?.object(forKey: "currencyBase") as? String
                
            let genderStr = PFUser.current()?.object(forKey: "gender") as? String
                if genderStr == "male" {
                    self.genderTxt.text = male_str
                } else {
                    self.genderTxt.text = female_str
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    // clicked cance button
    @IBAction func cancelclicked(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // alert function
    func alert (error: String, message: String) {
        let alert = UIAlertController(title: error, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    // restriction and email address validation function
    func validateEmail(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regex)
        
        return emailTest.evaluate(with: email)
        
        //let range = email.range(of: regex, options: .regularExpression)
        //let result = range != nil ? true : false
        //return result
    }

    // restriction and email address validation function
    func validateWeb (web: String) -> Bool {
        let regex = "www\\.+[A-Z0-9a-z._%+-]+\\.[A-Za-z]{2}"
        let range = web.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }

    @IBAction func currencyUsedBtn_clicked(_ sender: UIButton) {
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
    
    // clicked save button
    @IBAction func save_clicked(_ sender: AnyObject) {
        
        // validation according regex
        if !validateEmail(email: emailTxt.text!) {
            let okbtn = DefaultButton(title: ok_str, action: nil)
            let complMenu = PopupDialog(title: wrong_email_address_format_str, message: change_email_address_format_str)
            complMenu.addButtons([okbtn])
            self.present(complMenu, animated: true, completion: nil)
            return
        }
        if !validateWeb(web: webTxt.text!) {
            let okbtn = DefaultButton(title: ok_str, action: nil)
            let complMenu = PopupDialog(title: wrong_webpage_url_format_str, message: change_webpage_url_format_str)
            complMenu.addButtons([okbtn])
            self.present(complMenu, animated: true, completion: nil)
            return
        }
        
        // save filled in information
        let user = PFUser.current()!
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user["fullname"] = fullnameTxt.text?.lowercased()
        user["web"] = webTxt.text?.lowercased()
        user["bio"] = bioTxt.text
        user["currencyBase"] = self.currencyUsedBtn.titleLabel?.text
        
        if (telTxt.text!.isEmpty) {
            user["tel"] = ""
        } else {
            user["tel"] = telTxt.text
        }
        
        if (genderTxt.text!.isEmpty) {
            user["gender"] = ""
        } else {
            if genderTxt.text == male_str {
                user["gender"] = "male"
            } else {
                user["gender"] = "female"
            }
        }
        
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        // send filled info to server
        user.saveInBackground (block: { (success: Bool, error: Error?) in
            
            if success {
                
                // hide keyboard
                self.view.endEditing(true)
                
                // dismiss editVC
                self.dismiss(animated: true, completion: nil)
                
                // reload homeVC view controller
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reload"), object: nil)
            } else {
                print(error!.localizedDescription)
            }
        })
    }
}

// MARK: UIPopoverPresentationControllerDelegate
extension editVC: UIPopoverPresentationControllerDelegate {
    
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

// popoverDelegate procedure for currencies view field
extension editVC: CurrenciesPopoverDelegate {
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
            
            currencyUsedBtn.setTitle(currenciesArray.last!, for: .normal)
            currencyList = getCurrencyList(referenceCurrency: currenciesArray.last!)
        }
    }
}

