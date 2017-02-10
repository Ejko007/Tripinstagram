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
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itineraryCell", for: indexPath)
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    

}
