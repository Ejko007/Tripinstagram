//
//  spentHeaderCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit

class spentHeaderCell: UITableViewCell, UITableViewDelegate {

    @IBOutlet weak var spentTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // allow constraints
        spentTypeLbl.translatesAutoresizingMaskIntoConstraints = false
     
        // constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[spenttype]-|",
            options: [],
            metrics: nil, views: ["spenttype":spentTypeLbl]))
       
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[spenttype]-|",
            options: [],
            metrics: nil, views: ["spenttype":spentTypeLbl]))
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
