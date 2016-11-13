//
//  rateCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit

class rateCell: UITableViewCell {
    
    // UI objects
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameBtn: UIButton!
    @IBOutlet weak var commentLbl: KILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // set rate controller to precise
        rateView!.settings.fillMode = .precise
        rateView!.updateOnTouch = false
        rateView.starSize = 13.0
        rateView.frame.size.height = 13
        rateView.rating = 0.0

        
        // alignement
        avaImg.translatesAutoresizingMaskIntoConstraints = false
        usernameBtn.translatesAutoresizingMaskIntoConstraints = false
        commentLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        rateView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[username]-3-[rate]-3-[comment]-3-|",
            options: [],
            metrics: nil, views: ["username" : usernameBtn, "rate" : rateView, "comment" : commentLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-15-[date]",
            options: [],
            metrics: nil, views: ["date" : dateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[ava(40)]",
            options: [],
            metrics: nil, views: ["ava" : avaImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[ava(40)]-13-[comment]-20-|",
            options: [],
            metrics: nil, views: ["ava" : avaImg, "comment" : commentLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[ava]-13-[username]",
            options: [],
            metrics: nil, views: ["ava" : avaImg, "username" : usernameBtn]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[ava]-13-[rate]",
            options: [],
            metrics: nil, views: ["ava" : avaImg, "rate" : rateView]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[date]-10-|",
            options: [],
            metrics: nil, views: ["date" : dateLbl]))

        // round ava picture
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
    }
}
