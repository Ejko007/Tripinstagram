//
//  itineraryCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

class itineraryCell: UITableViewCell, UITableViewDelegate {
    
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var instructionLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        instructionLbl.translatesAutoresizingMaskIntoConstraints = false
        orderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        orderLabel.layer.masksToBounds = true
        orderLabel.layer.cornerRadius = 5
        orderLabel.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
        orderLabel.textColor = .white
        orderLabel.frame.size = CGSize(width: 40, height: 30)

        // constraints settings
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-15-[orderlbl]-15-|",
            options: [],
            metrics: nil, views: ["orderlbl":orderLabel]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[instrlabel]-10-|",
            options: [],
            metrics: nil, views: ["instrlabel":instructionLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[orderlbl(40)]-10-[instrlabel]-0-|",
            options: [],
            metrics: nil, views: ["orderlbl":orderLabel, "instrlabel":instructionLbl]))
        
    }

}
