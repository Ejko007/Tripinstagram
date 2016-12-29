//
//  spentCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import Foundation

class spentCell: UITableViewCell, UITableViewDelegate {
    
    @IBOutlet weak var spentDateLbl: UILabel!
    @IBOutlet weak var spentNameLbl: UILabel!
    @IBOutlet weak var spentAmountLbl: UILabel!
    @IBOutlet weak var spentCurrencyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // allow constraints
        spentDateLbl.translatesAutoresizingMaskIntoConstraints = false
        spentNameLbl.translatesAutoresizingMaskIntoConstraints = false
        spentAmountLbl.translatesAutoresizingMaskIntoConstraints = false
        spentCurrencyLbl.translatesAutoresizingMaskIntoConstraints = false
 
        // constraints
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[spentdate]-|",
            options: [],
            metrics: nil, views: ["spentdate":spentDateLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[spentname]-20-[spentamount]-10-|",
            options: [],
            metrics: nil, views: ["spentname":spentNameLbl,"spentamount":spentAmountLbl]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[spentcurrency]-10-|",
            options: [],
            metrics: nil, views: ["spentcurrency":spentCurrencyLbl]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[spentdate(80)]-10-[spentname]-10-|",
            options: [],
            metrics: nil, views: ["spentdate":spentDateLbl, "spentname":spentNameLbl]))
  
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[spentdate(80)]-10-[spentamount(180)]-10-[spentcurrency(40)]-10-|",
            options: [],
            metrics: nil, views: ["spentdate":spentDateLbl, "spentamount":spentAmountLbl, "spentcurrency":spentCurrencyLbl]))
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
