//
//  countriesCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

class countriesCell: UITableViewCell {
    
    @IBOutlet weak var countryImg: UIImageView!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // add constraints
        countryImg.translatesAutoresizingMaskIntoConstraints = false
        countryNameLbl.translatesAutoresizingMaskIntoConstraints = false
        countryCodeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[flagpicture]-10-|",
            options: [],
            metrics: nil, views: ["flagpicture":countryImg]))
       
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[countryname]",
            options: [],
            metrics: nil, views: ["countryname":countryNameLbl]))
 
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[countrycode]-5-|",
            options: [],
            metrics: nil, views: ["countrycode":countryCodeLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[flagpicture(30)]-10-[countryname]-10-|",
            options: [],
            metrics: nil, views: ["flagpicture":countryImg, "countryname":countryNameLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[flagpicture(30)]-10-[countrycode]-10-|",
            options: [],
            metrics: nil, views: ["flagpicture":countryImg, "countrycode":countryCodeLbl]))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        accessoryType = selected ? .checkmark : .none
    }

}
