//
//  PromoContentViewController.swift
//  ImageViewer
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 MailOnline. All rights reserved.
//

import UIKit

class PromoContentViewController: UIViewController {
    
    
    @IBOutlet weak var promoImageView: UIImageView!
    
    var pageIndex = 0
    // var imageName: String?
    var photoImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        promoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[imageview(200)]",
            options: [],
            metrics: nil, views: ["imageview":promoImageView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[imageview]-0-|",
            options: [],
            metrics: nil, views: ["imageview":promoImageView]))

        if let currentImage = photoImage {  // imageName
            // promoImageView.image = UIImage(named: currentImage)
            promoImageView.image = currentImage
        }
    }

}
