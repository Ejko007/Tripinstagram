//
//  PhotoViewController.swift
//  SimpleCamera
//
//  Created by Simon Ng on 16/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class photoVC: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var navbar: UINavigationBar!
    
    var image:UIImage?
    
    // size of screen
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set navigation bar properties
        navbar.frame = CGRect(x: 0, y: 0, width: self.width, height: 65)
        navbar.barTintColor = UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)
        navbar.isTranslucent = false
        navbar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        navbar.backgroundColor = .white
        navbar.tintColor = .white
        navbar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = camera_str.uppercased()
        
        // Create left and right button for navigation item
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backBtn
        backBtn.tintColor = .white
        let editBtn = UIBarButtonItem(image: UIImage(named: "accept.png"), style: .plain, target: self, action: #selector(saveTapped))
        navigationItem.rightBarButtonItem = editBtn
        editBtn.tintColor = .white
        
        // Assign the navigation item to the navigation bar
        navbar.items = [navigationItem]
        
        // allow constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        navbar.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[navbar(\(width))]-0-|",
            options: [],
            metrics: nil, views: ["navbar":navbar]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[imageview(\(width))]-0-|",
            options: [],
            metrics: nil, views: ["imageview":imageView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[navbar(65)]-0-[imageview(\(height - 65))]-|",
            options: [],
            metrics: nil, views: ["navbar":navbar,"imageview":imageView]))

        imageView.image = image
    }
    
    // return back to previous screen
    func back() {
        //push back
        self.dismiss(animated: true, completion: nil)
    }
    
    // save/accpt button pressed and save picture to photoalbum
    func saveTapped() {
        guard let imageToSave = image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        dismiss(animated: true, completion: nil)
     }

}
