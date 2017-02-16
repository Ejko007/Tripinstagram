//
//  itineraryHeaderCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

class itineraryHeaderCell: UITableViewCell {

    @IBOutlet weak var geopointIcon: UIImageView!
    @IBOutlet weak var geopointDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        geopointIcon.translatesAutoresizingMaskIntoConstraints = false
        geopointDescription.translatesAutoresizingMaskIntoConstraints = false
       
        let iconImage = UIImage(named: "chooser-moment-icon-place")
        geopointIcon.frame.size = CGSize(width: 30, height: 30)
        geopointIcon.image = iconImage?.imageResize(sizeChange: CGSize(width: 30, height: 30))
        geopointIcon.contentMode = UIViewContentMode.center
        // geopointIcon.backgroundColor = UIColor.clear
        
        // geopoint description initial settings
        geopointDescription.isEditable = false
        geopointDescription.isSelectable = false
        geopointDescription.isScrollEnabled = true
        geopointDescription.layer.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: 40)
        
        // constraints settings
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-25-[geopointicon]-25-|",
            options: [],
            metrics: nil, views: ["geopointicon":geopointIcon]))
       
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[geopointdesc]-|",
            options: [],
            metrics: nil, views: ["geopointdesc":geopointDescription]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-5-[geopointicon]-10-[geopointdesc]-5-|",
            options: [],
            metrics: nil, views: ["geopointicon":geopointIcon, "geopointdesc":geopointDescription]))
    }

}
