//
//  singInVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog

class singInVC: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    // Text fields
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    // Buttons
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    

    // default function
    override func viewDidLoad() {
        super.viewDidLoad()

        // Font of label
        label.font = UIFont(name: "Pacifico", size: 25)
        
        
        // alignement
        label.frame = CGRect(x: 10, y: 80, width: self.view.frame.size.width - 20, height: 50)
        usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 70, width: self.view.frame.size.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 40, width: self.view.frame.size.width - 20, height: 30)
        forgotBtn.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 30, width: self.view.frame.size.width - 20, height: 30)
        signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y + 40, width: self.view.frame.size.width / 3, height: 30)
        signInBtn.layer.cornerRadius = signInBtn.frame.size.width / 20
        signUpBtn.frame = CGRect(x: self.view.frame.size.width - self.view.frame.size.width / 3 - 20, y: signInBtn.frame.origin.y, width: self.view.frame.size.width / 3, height: 30)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.size.width / 20
    
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        
    }
    
    // hide keyboard
    func hideKeyboard (recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }

    
    @IBAction func signInBtn_click(_ sender: AnyObject) {
        
        // hide keyboard
        self.view.endEditing(true)
        
        // if text field are empty
        if (usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty) {
            
            // Show alert mesage
            
            let alert = PopupDialog(title: error_str, message: no_login_and_password_error_str)
            let ok = DefaultButton(title: ok_str, action: nil)
            alert.addButtons([ok])
            self.present(alert, animated: true, completion: nil)
            
        }
        
        // login function
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:Error?) in
            
            if error == nil {
                
                // remeber user or save in memory did the user login or not
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                // call login function from AppDelegate.swoft class
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
}
