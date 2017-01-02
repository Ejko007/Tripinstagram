//
//  tripsListCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit

class tripsListCell: UITableViewCell, UITableViewDelegate {

    @IBOutlet weak var triplistCategoryLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // allow constraints
        triplistCategoryLbl.translatesAutoresizingMaskIntoConstraints = false
       
        // constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[listcategory]-|",
            options: [],
            metrics: nil, views: ["listcategory":triplistCategoryLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[listcategory]-|",
            options: [],
            metrics: nil, views: ["listcategory":triplistCategoryLbl]))
        
        triplistCategoryLbl.font = UIFont(name: triplistCategoryLbl.font.fontName, size: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
