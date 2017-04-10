//
//  signUPVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog

class signUPVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currencyUsedBtn: UIButton!
    @IBOutlet weak var currencyUsedTxt: UITextField!


    // Reset default size
    var scrollViewHeigh : CGFloat = 0
    
    // Keyboard frame size
    var keyboard = CGRect()
    
    var countriesInfo = [countryInfo]()
    var currencyList = [Currency]()
 
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let width = self.view.frame.size.width

        //scrollview frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeigh = scrollView.frame.size.height
        
        //check notification if keyboard is shown or hide
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        // Declare hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // roud ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(loadImg(recognizer:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
        
        //alignement
        avaImg.frame = CGRect(x: self.view.frame.width / 2 - 40, y: 40, width: 80, height: 80)
        usernameTxt.frame = CGRect(x: 10, y: avaImg.frame.origin.y + 90, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        repeatPasswordTxt.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        emailTxt.frame = CGRect(x: 10, y: repeatPasswordTxt.frame.origin.y + 60, width: self.view.frame.size.width - 20, height: 30)
        fullnameTxt.frame = CGRect(x: 10, y: emailTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        bioTxt.frame = CGRect(x: 10, y: fullnameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        webTxt.frame = CGRect(x: 10, y: bioTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        
        currencyUsedTxt.frame = CGRect(x: 10, y: webTxt.frame.origin.y + 40, width: width - 70, height: 30)
        currencyUsedTxt.text = currency_used_str
        currencyUsedTxt.isEnabled = false
        currencyUsedBtn.frame = CGRect(x: width - 50, y: webTxt.frame.origin.y + 40, width: 40, height: 30)
        currencyUsedBtn.backgroundColor = .white
        currencyUsedBtn.layer.cornerRadius = 5
        currencyUsedBtn.layer.borderWidth = 1
        currencyUsedBtn.layer.borderColor = UIColor.gray.cgColor
        
        signUpBtn.frame = CGRect(x: 20, y: currencyUsedTxt.frame.origin.y + 50, width: self.view.frame.size.width / 3, height: 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
        
        cancelBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 3 - 20, y: signUpBtn.frame.origin.y, width: self.view.frame.size.width / 3, height: 30)
        cancelBtn.layer.cornerRadius = cancelBtn.frame.size.width / 20
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    
    }
    
    func loadImg (recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    // Connect selected image to our ImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    // Hide keyboard if tap
    func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func showKeyboard (notification: NSNotification) {
   
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            self.scrollView.contentInset = UIEdgeInsets.zero
        } else {
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
  
        self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        
        self.scrollView.scrollRectToVisible(keyboardScreenEndFrame, animated: true)
    }

    func hideKeyboard (notification: NSNotification) {
        
        // Move down UI
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    //clicked Sign Up
    @IBAction func signUpBtn_click(_ sender: AnyObject) {
        
        //dismiss keyboard
        self.view.endEditing(true)
        
        // if fields are empty
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPasswordTxt.text!.isEmpty || emailTxt.text!.isEmpty || bioTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || webTxt.text!.isEmpty) {
            
            // error mesage
            let alert = PopupDialog(title: error_str, message: all_fields_no_empty_str)
            let ok = DefaultButton(title: ok_str, action: nil)
            alert.addButtons([ok])
            self.present(alert, animated: true, completion: nil)
           
            return
        }
        
        // if password fileds do not match
        if passwordTxt.text != repeatPasswordTxt.text {
        // error mesage
            
            let alert = PopupDialog(title: error_str, message: password_fields_no_match)
            let ok = DefaultButton(title: ok_str, action: nil)
            alert.addButtons([ok])
            self.present(alert, animated: true, completion: nil)
            
            return
        }
            
        // Send data to server to related columns
        let user = PFUser()
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user.password = passwordTxt.text
        user["fullname"] = fullnameTxt.text?.lowercased()
        user["bio"] = bioTxt.text
        user["web"] = webTxt.text?.lowercased()
        // In edit profile it's gonna be assigned
        user["tel"] = ""
        user["gender"] = "male"
        user["currencyBase"] = currencyUsedBtn.titleLabel?.text

        // convert our image for sending to serever
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
            
        // Save data to server
        user.signUpInBackground { (success, error) -> Void in
            
            if success {
                
                let alert = PopupDialog(title: registration_str, message: registration_successful_str)
                let ok = DefaultButton(title: ok_str, action: nil)
                alert.addButtons([ok])
                self.present(alert, animated: true, completion: nil)
                                
                // remember logged in user
                UserDefaults.standard.set(user.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                // Call login func from Appdelegate swift class
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
                
                
            } else {
                
                // Show alert mesage
                let alert = PopupDialog(title: error_str, message: error!.localizedDescription)
                let ok = DefaultButton(title: ok_str, action: nil)
                alert.addButtons([ok])
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }

    @IBAction func cancelBtn_click(_ sender: AnyObject) {
        
        // hide keyboard
        self.view.endEditing(true)
        
        self.dismiss(animated: true, completion: nil)
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
}

// MARK: UIPopoverPresentationControllerDelegate
extension signUPVC: UIPopoverPresentationControllerDelegate {
    
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
extension signUPVC: CurrenciesPopoverDelegate {
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

