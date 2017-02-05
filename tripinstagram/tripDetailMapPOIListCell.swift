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
    @IBOutlet weak var POIOrderLbl: UILabel!
    
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
        POIOrderLbl.translatesAutoresizingMaskIntoConstraints = false
        
        // set frame size for show description button icon
        showDescriptionBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        // set frame size for poiorder label
        POIOrderLbl.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        POIOrderLbl.layer.cornerRadius = 15.0
        POIOrderLbl.clipsToBounds = true
        POIOrderLbl.backgroundColor = UIColor(red: 223 / 255, green: 0, blue: 31 / 255, alpha: 1)
        POIOrderLbl.textColor = .white
        self.contentView.addSubview(POIOrderLbl)
        
        // configure backgroud color of POI name
        POIName.backgroundColor = UIColor(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 30 / 100)
        POIName.tintColor = .black
        
        
        // localization of label text
        LatitudeLbl.text = latitude_str
        LatitudeLbl.textAlignment = .center
        LongtitudeLbl.text = longitude_str
        LongtitudeLbl.textAlignment = .center
        
        // hide description txt view
        POIDescriptionTxtView.isHidden = true
        POIUUID.isHidden = true
        
        // poitype label settings
        POITypeView.frame = CGRect(x: 0, y: 0, width: width - 140, height: 110)
        POITypeView.layer.cornerRadius = 5.0
        POITypeView.clipsToBounds = true
        self.contentView.addSubview(POITypeView)
        
        // add constraints to both subview and cell view
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
            withVisualFormat: "H:[poiorder(30)]-10-|",
            options: [],
            metrics: nil,
            views: ["poiorder":POIOrderLbl]))

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
            withVisualFormat: "V:|-10-[poiname]-10-[poidesc]-10-[poitypeview(\(POITypeView.frame.height))]-10-|",
            options: [],
            metrics: nil,
            views: ["poiname":POIName, "poidesc":POIDescription, "poitypeview":POITypeView]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[poiname]-10-[poidesc]-10-[poiorder(30)]",
            options: [],
            metrics: nil,
            views: ["poiname":POIName, "poidesc":POIDescription,"poiorder":POIOrderLbl]))

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
