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

    // Reset default size
    var scrollViewHeigh : CGFloat = 0
    
    // Keyboard frame size
    var keyboard = CGRect()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        //scrollview frame size
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeigh = scrollView.frame.size.height
        
        //check notification if keyboard is shown or hide
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
       
        //NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
        
        signUpBtn.frame = CGRect(x: 20, y: webTxt.frame.origin.y + 50, width: self.view.frame.size.width / 3, height: 30)
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
        user["gender"] = ""

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
    
}
