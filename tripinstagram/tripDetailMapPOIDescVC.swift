//
//  tripDetailMapPOIDescVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

var descriptionuuid = String()

class tripDetailMapPOIDescVC: UIViewController {

    @IBOutlet weak var tripDetailDescLabel: UILabel!
    @IBOutlet weak var tripDetailTxtView: UITextView!
    @IBOutlet weak var tripDetailDescSaveBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // hide keyboard tap
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // set textview parameters
        tripDetailTxtView.backgroundColor = UIColor(colorLiteralRed: 242.0 / 255, green: 242.0 / 255, blue: 242.0 / 255, alpha: 1)
        tripDetailTxtView.layer.cornerRadius = 5.0
        tripDetailTxtView.clipsToBounds = true
        
        // localize button and label text
        tripDetailDescLabel.text = description_str
        tripDetailDescSaveBtn.setTitle(save_str,for: .normal)
        
        // add constraints
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        tripDetailDescLabel.translatesAutoresizingMaskIntoConstraints = false
        tripDetailTxtView.translatesAutoresizingMaskIntoConstraints = false
        tripDetailDescSaveBtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[desclbl(\(width - 20))]-10-|",
            options: [],
            metrics: nil, views: ["desclbl":tripDetailDescLabel]))
       
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[desctxtview(\(width - 20))]-10-|",
            options: [],
            metrics: nil, views: ["desctxtview":tripDetailTxtView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[savebtn(\(width - 20))]-10-|",
            options: [],
            metrics: nil, views: ["savebtn":tripDetailDescSaveBtn]))
        
        let h = self.tabBarController?.tabBar.frame.height
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[desclbl(30)]-10-[desctxtview(\(height - (h! + 160)))]-10-[savebtn(30)]-10-|",
            options: [],
            metrics: nil, views: ["desclbl":tripDetailDescLabel,"desctxtview":tripDetailTxtView, "savebtn":tripDetailDescSaveBtn]))
        
        // load data
        tripDetailTxtView.text = descriptionuuid
    }

    // go back function
    func back(sender: UIBarButtonItem) {
        
        //push back
        if !descriptionuuid.isEmpty {
            descriptionuuid = ""
        }

        self.dismiss(animated: true, completion: nil)
    }

    // hide keyboard func
    func hideKeyboardTap () {
        self.view.endEditing(true)
    }
    
    @IBAction func tripDetailDescButtonTapped(_ sender: Any) {
        
        descriptionuuid = tripDetailTxtView.text
        print(descriptionuuid)
        // go back to previous view controller
        _ = navigationController?.popViewController(animated: true)
    }
}
