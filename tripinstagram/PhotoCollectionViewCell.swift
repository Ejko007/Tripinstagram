//
//  PhotoCollectionViewCell.swift
//  ImageViewer
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 MailOnline. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[photoimage]-|",
            options: [],
            metrics: nil, views: ["photoimage":photoImageView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[photoimage]-|",
            options: [],
            metrics: nil, views: ["photoimage":photoImageView]))
        
    }
    
}
