//
//  itineraryFooterCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

class itineraryFooterCell: UITableViewCell {

    @IBOutlet weak var geopointIcon: UIImageView!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var kmLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        geopointIcon.translatesAutoresizingMaskIntoConstraints = false
        distanceLbl.translatesAutoresizingMaskIntoConstraints = false
        kmLbl.translatesAutoresizingMaskIntoConstraints = false
        
        let iconImage = UIImage(named: "Point Objects")
        geopointIcon.frame.size = CGSize(width: 30, height: 30)
        geopointIcon.image = iconImage?.imageResize(sizeChange: CGSize(width: 30, height: 30))
        geopointIcon.contentMode = UIViewContentMode.center
        
        // constraints settings
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-25-[geopointicon]-25-|",
            options: [],
            metrics: nil, views: ["geopointicon":geopointIcon]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[distancelbl]-|",
            options: [],
            metrics: nil, views: ["distancelbl":distanceLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[kmlbl]-|",
            options: [],
            metrics: nil, views: ["kmlbl":kmLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-5-[geopointicon]-10-[distancelbl]-5-[kmlbl]",
            options: [],
            metrics: nil, views: ["geopointicon":geopointIcon, "distancelbl":distanceLbl, "kmlbl":kmLbl]))
        
     }

}
