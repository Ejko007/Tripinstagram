//
//  editVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

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
    
    // pickerView & pickerData
    var genderPicker = UIPickerView()
    let genders = ["muž","žena"]
    
    // keyboard to hold frame size
    var keyboard = CGRect()
    
    
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
        genderTxt.frame = CGRect(x: 10, y: telTxt.frame.origin.y + 40, width: width - 20, height: 30)
        
        titleLbl.frame = CGRect(x: 15, y: emailTxt.frame.origin.y - 30, width: width - 20, height: 30)
        
        
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
            self.genderTxt.text = PFUser.current()?.object(forKey: "gender") as? String
            } else {
                print(error?.localizedDescription as Any)
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

    
    // clicked save button
    @IBAction func save_clicked(_ sender: AnyObject) {
        
        // validation according regex
        if !validateEmail(email: emailTxt.text!) {
            alert(error: "Špatný formát emailové adresy", message: "Opravte prosím formát emailové adresy.")
            return
        }
        if !validateWeb(web: webTxt.text!) {
            alert(error: "Špatný formát webové stránky", message: "Opravte prosím formát webové stránky.")
            return
        }
        
        // save filled in information
        let user = PFUser.current()!
        user.username = usernameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user["fullname"] = fullnameTxt.text?.lowercased()
        user["web"] = webTxt.text?.lowercased()
        user["bio"] = bioTxt.text
        
        if (telTxt.text?.isEmpty)! {
            user["tel"] = ""
        } else {
            user["tel"] = telTxt.text
        }
        
        if (genderTxt.text?.isEmpty)! {
            user["gender"] = ""
        } else {
            user["gender"] = genderTxt.text
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
                print(error?.localizedDescription as Any)
            }
        })
    }
}
