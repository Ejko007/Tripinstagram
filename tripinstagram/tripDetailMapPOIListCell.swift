//
//  tripDetailMapPOIListCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

class tripDetailMapPOIListCell: UITableViewCell {
    
    @IBOutlet weak var POIName: UILabel!
    @IBOutlet weak var POIDescription: UILabel!
    @IBOutlet weak var LatitudeLbl: UILabel!
    @IBOutlet weak var LongtitudeLbl: UILabel!
    @IBOutlet weak var LatitudeValueLbl: UILabel!
    @IBOutlet weak var LongtitudeValueLbl: UILabel!
    @IBOutlet weak var showDescriptionBtn: UIButton!
    @IBOutlet weak var POIDescriptionTxtView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // add contraints
        addConstraints()
        
    }

    // constraints
    func addConstraints() {
        
        // size of screen
        let width = UIScreen.main.bounds.width
        
        POIName.translatesAutoresizingMaskIntoConstraints = false
        POIDescription.translatesAutoresizingMaskIntoConstraints = false
        LatitudeLbl.translatesAutoresizingMaskIntoConstraints = false
        LongtitudeLbl.translatesAutoresizingMaskIntoConstraints = false
        LatitudeValueLbl.translatesAutoresizingMaskIntoConstraints = false
        LongtitudeValueLbl.translatesAutoresizingMaskIntoConstraints = false
        showDescriptionBtn.translatesAutoresizingMaskIntoConstraints = false
        POIDescriptionTxtView.translatesAutoresizingMaskIntoConstraints = false
        
        // set frame size for show description button icon
        showDescriptionBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        // hide description txt view
        POIDescriptionTxtView.isHidden = true
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poiname]-10-|",
            options: [],
            metrics: nil,
            views: ["poiname":POIName]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poidescription]-10-|",
            options: [],
            metrics: nil,
            views: ["poidescription":POIDescription]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[latdesc(\((width / 2) - 15))]",
            options: [],
            metrics: nil,
            views: ["latdesc":LatitudeLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[latvalue(\((width / 2) - 15))]",
            options: [],
            metrics: nil,
            views: ["latvalue":LatitudeValueLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[longdesc(\((width / 2) - 15))]",
            options: [],
            metrics: nil,
            views: ["longdesc":LongtitudeLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[longvalue(\((width / 2) - 15))]",
            options: [],
            metrics: nil,
            views: ["longvalue":LongtitudeValueLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[showpoidescbtn(30)]-10-|",
            options: [],
            metrics: nil,
            views: ["showpoidescbtn":showDescriptionBtn]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[poiname]-10-[poidesc]-10-[latlbl]-5-[latvalue]-10-[longlbl]-5-[longvalue]-10-|",
            options: [],
            metrics: nil,
            views: ["poiname":POIName, "poidesc":POIDescription, "latlbl":LatitudeLbl, "latvalue":LatitudeValueLbl, "longlbl":LongtitudeLbl, "longvalue":LongtitudeValueLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[showpoidescbtn(30)]-10-|",
            options: [],
            metrics: nil,
            views: ["showpoidescbtn":showDescriptionBtn]))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
