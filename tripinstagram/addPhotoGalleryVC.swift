//
//  addPhotoGalleryVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class addPhotoGalleryVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var pcImg: UIImageView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    //let pictureWidth = width - 20
    let pictureWidth = UIScreen.main.bounds.width - 20
    
    var tripuuid = String()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // constraints setting
        pcImg.translatesAutoresizingMaskIntoConstraints = false
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        
        let navheight = Int((self.navigationController?.navigationBar.frame.height)!) + Int(UIApplication.shared.statusBarFrame.size.height)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(\(navheight + 15))-[picture(\(pictureWidth))]-10-[removebtn(30)]",
            options: [],
            metrics: nil, views: ["picture":pcImg, "removebtn":removeBtn]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[savebtn]-10-|",
            options: [],
            metrics: nil, views: ["savebtn":saveBtn]))
       
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[picture]-|",
            options: [],
            metrics: nil, views: ["picture":pcImg]))
       
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[removebtn]-|",
            options: [],
            metrics: nil, views: ["removebtn":removeBtn]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[savebtn]-|",
            options: [],
            metrics: nil, views: ["savebtn":saveBtn]))
        
        
        // title label at the top
        self.navigationItem.title = new_snapshot_str.uppercased()
        self.navigationController?.navigationBar.topItem?.title = back_str
        
        // disable save btn by default
        saveBtn.isEnabled = false
        saveBtn.backgroundColor = .lightGray
        saveBtn.titleLabel!.text = save_str
        
        // hide remove button
        removeBtn.isHidden = true
        
        // standard UI containt
        pcImg.image = UIImage(named: "pbg.png")
        
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
        
    }
    
    
    // preload function
    override func viewWillAppear(_ animated: Bool) {
        
        // call alignement func
        // alignement()
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
        let picspace = self.view.frame.size.height - navheight - tabbarheight + 40
        let picshift = picspace / 2 - pictureWidth / 2

        // define frame of zoomed image
        let zoomed = CGRect(x: 0, y: navheight + picshift, width: self.view.frame.size.width, height: self.view.frame.size.width)
        
        // frame of unzoomed (small) image
        //let unzoomed = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
        let unzoomed = CGRect(x: 15, y: navheight + 15, width: pictureWidth - 10, height: pictureWidth)
        
        // id picture is unzoomed, zoom it
        if pcImg.frame == unzoomed {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.pcImg.frame = zoomed
                
                // hide objects from background
                self.view.backgroundColor = .black
                self.saveBtn.alpha = 0
                
                // hide remove button
                self.removeBtn.isHidden = true
                
            })
        } else {
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.pcImg.frame = unzoomed
                
                // unhide objects from background
                self.view.backgroundColor = .white
                self.saveBtn.alpha = 1
                
                // unhide remove button
                self.removeBtn.isHidden = false
            })
        }
    }
    
    // fields alignement function
    func alignement () {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        saveBtn.frame = CGRect(x: 0, y: height / 1.09, width: width, height: width / 8)
        
        removeBtn.frame = CGRect(x: pcImg.frame.origin.x, y: 15 + pcImg.frame.origin.y + 10 + pcImg.frame.size.height + 15, width: pcImg.frame.size.width, height: 20)
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
        
        // dismiss keyboard
        self.view.endEditing(true)
        
        // send data to server
        let object = PFObject(className: "photos")
        
        object["uuid"] = tripuuid
        
        // send pic to server after compression
        let imageData = UIImageJPEGRepresentation(pcImg.image!, 0.5)
        let imageFile = PFFile(name: "post.jpg", data: imageData!)
        object["picture"] = imageFile
        
        // finally save information
        object.saveInBackground (block: { (success:Bool, error: Error?) in
            if error == nil {
                
                // send notification wiht name "uploaded"
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
                
                // switch to another ViewController at 0 index of tabbar
                // self.tabBarController!.selectedIndex = 0
                
                // reset everything
                self.viewDidLoad()
            }
        })
    }

}
