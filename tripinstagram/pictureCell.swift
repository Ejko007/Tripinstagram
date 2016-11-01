//
//  pictureCell.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit

class pictureCell: UICollectionViewCell {
    
    @IBOutlet weak var picImg: UIImageView!
    
    // default func
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignement
        let width = UIScreen.main.bounds.width
        
        picImg.frame = CGRect(x: 0, y: 0, width: width / 3, height: width / 3)
        
    }
    
}
