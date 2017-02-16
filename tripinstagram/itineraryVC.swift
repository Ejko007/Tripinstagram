//
//  itineraryVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

class itineraryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var kmLbl: UILabel!
    @IBOutlet weak var itineraryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color setting
        //self.view.backgroundColor = UIColor(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 30 / 100)

        // add contraints
        distanceLbl.translatesAutoresizingMaskIntoConstraints = false
        kmLbl.translatesAutoresizingMaskIntoConstraints = false
        mapIcon.translatesAutoresizingMaskIntoConstraints = false
        itineraryTableView.translatesAutoresizingMaskIntoConstraints = false
                
        // constraints settings
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(-10)-[mapicon(80)]-10-[tableView]-|",
            options: [],
            metrics: nil, views: ["mapicon":mapIcon,"tableView":itineraryTableView]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[distanceLbl(38)]",
            options: [],
            metrics: nil, views: ["distanceLbl":distanceLbl]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[kmLbl(38)]",
            options: [],
            metrics: nil, views: ["kmLbl":kmLbl]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[mapicon(80)]",
            options: [],
            metrics: nil, views: ["mapicon":mapIcon]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[distanceLbl]-10-[kmLbl]-10-|",
            options: [],
            metrics: nil, views: ["distanceLbl":distanceLbl,"kmLbl":kmLbl]))
 
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[tableView]-|",
            options: [],
            metrics: nil, views: ["tableView":itineraryTableView]))

        // configuring itinerary header size
        let font = UIFont(name: "Avenir Next", size: 38)
        distanceLbl.font = font
        kmLbl.font = font
        
        let total = calculateDistance()
        distanceLbl.text = "\(total)"
        
        itineraryTableView.delegate = self
        itineraryTableView.dataSource = self
        
        itineraryTableView.estimatedRowHeight = 60
        itineraryTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // calculate total distance
    func calculateDistance() -> Double {
        var suma = Double()
       
        suma = 0
        if itineraryDistances.count != 0 {
            for i in 0...itineraryDistances.count - 1 {
                suma = suma + itineraryDistances[i]
            }
        }
        
        return suma.roundTo(places: 2)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath) as! itineraryCell

        cell.instructionLbl.text = itineraryInstructionsArray[indexPath.section][indexPath.row]
        cell.orderLabel.text = "\(indexPath.row + 1)."
        
        return cell
        
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headercell = tableView.dequeueReusableCell(withIdentifier: "itineraryHeaderCell") as! itineraryHeaderCell
        if geoplacemarkArray.count != 0 {
            let description = geoplacemarkArray[section].locationName + "\r\n" +
                geoplacemarkArray[section].cityName + "\r\n" +
                geoplacemarkArray[section].zipName + "\r\n" +
                geoplacemarkArray[section].countryName
            
            // headercell.geopointDescription.text = description
            headercell.geopointDescription.insertText(description)
            headercell.layer.cornerRadius = 10.0
            headercell.clipsToBounds = true
            headercell.layer.borderWidth = 1
            headercell.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        return headercell
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footercell = tableView.dequeueReusableCell(withIdentifier: "itineraryFooterCell") as! itineraryFooterCell

        if geoplacemarkArray.count != 0 {
            footercell.distanceLbl.text = "\(itineraryDistances[section])"
            footercell.kmLbl.text = km_str
            footercell.contentView.layer.cornerRadius = 5.0
            footercell.contentView.clipsToBounds = true
            footercell.contentView.layer.borderWidth = 1
            footercell.contentView.backgroundColor = .white
            footercell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        return footercell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 55.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return itineraryDistances.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itineraryInstructionsArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    

}
