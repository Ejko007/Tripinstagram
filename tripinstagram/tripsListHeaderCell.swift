//
//  tripsListHeaderCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit

class tripsListHeaderCell: UITableViewCell, UITableViewDelegate {

    @IBOutlet weak var triplistDateLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // allow constraints
        triplistDateLbl.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[triplistdate]-|",
            options: [],
            metrics: nil, views: ["triplistdate":triplistDateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[triplistdate]-|",
            options: [],
            metrics: nil, views: ["triplistdate":triplistDateLbl]))
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
