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
    @IBOutlet weak var POIUUID: UILabel!
    @IBOutlet weak var POITypeView: UIView!
    
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
        POIUUID.translatesAutoresizingMaskIntoConstraints = false
        POITypeView.translatesAutoresizingMaskIntoConstraints = false
        
        // set frame size for show description button icon
        showDescriptionBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        // configure backgroud color of POI name
        POIName.backgroundColor = UIColor(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 30 / 100)
        POIName.tintColor = .black
        POIName.drawText(in: CGRect(x: 5, y: 20, width: width - 20, height: 20))
        
        
        // localization of label text
        LatitudeLbl.text = latitude_str
        LongtitudeLbl.text = longitude_str
        
        // hide description txt view
        POIDescriptionTxtView.isHidden = true
        POIUUID.isHidden = true
        
        POITypeView.frame = CGRect(x: 0, y: 0, width: width - 140, height: 110)
        POITypeView.layer.cornerRadius = 5.0
        POITypeView.clipsToBounds = true
        self.contentView.addSubview(POITypeView)
        
        // add constraints to both subview and cell view
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poiname(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poiname":POIName]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poidescription(\(width - 20))]-10-|",
            options: [],
            metrics: nil,
            views: ["poidescription":POIDescription]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[poitypeview(\(POITypeView.frame.width))]",
            options: [],
            metrics: nil,
            views: ["poitypeview":POITypeView]))
        
        self.POITypeView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[latdesc(\(POITypeView.frame.width - 10))]",
            options: [],
            metrics: nil,
            views: ["latdesc":LatitudeLbl]))

        self.POITypeView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[latvalue(\(POITypeView.frame.width - 10))]",
            options: [],
            metrics: nil,
            views: ["latvalue":LatitudeValueLbl]))

        self.POITypeView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[longdesc(\(POITypeView.frame.width - 10))]",
            options: [],
            metrics: nil,
            views: ["longdesc":LongtitudeLbl]))

        self.POITypeView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[longvalue(\(POITypeView.frame.width - 10))]",
            options: [],
            metrics: nil,
            views: ["longvalue":LongtitudeValueLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[showpoidescbtn(30)]-10-|",
            options: [],
            metrics: nil,
            views: ["showpoidescbtn":showDescriptionBtn]))
        
        self.POITypeView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[latlbl]-5-[latvalue]-5-[longlbl]-5-[longvalue]-10-|",
            options: [],
            metrics: nil,
            views: ["latlbl":LatitudeLbl, "latvalue":LatitudeValueLbl, "longlbl":LongtitudeLbl, "longvalue":LongtitudeValueLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[poiname(20)]-10-[poidesc(15)]-10-[poitypeview(\(POITypeView.frame.height))]-10-|",
            options: [],
            metrics: nil,
            views: ["poiname":POIName, "poidesc":POIDescription, "poitypeview":POITypeView]))
        
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
