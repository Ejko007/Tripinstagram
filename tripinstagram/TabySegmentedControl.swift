//
//  TabySegmentedControl.swift
//  UISegmentedControlAsTabbarDemo
//
//  Created by Ahmed Abdurrahman on 9/16/15.
//  Copyright © 2015 A. Abdurrahman. All rights reserved.
//

import UIKit

class TabySegmentedControl: UISegmentedControl {
    
    func initUI(){
        setupBackground()
        setupFonts()
    }
    
    func setupBackground(){
        let backgroundImage = UIImage(named: "segmented_unselected_bg")
        let dividerImage = UIImage(named: "segmented_separator_bg")
        let backgroundImageSelected = UIImage(named: "segmented_selected_bg")
        
        self.setBackgroundImage(backgroundImage, for: UIControlState(), barMetrics: .default)
        self.setBackgroundImage(backgroundImageSelected, for: .highlighted, barMetrics: .default)
        self.setBackgroundImage(backgroundImageSelected, for: .selected, barMetrics: .default)
        
        self.setDividerImage(dividerImage, forLeftSegmentState: UIControlState(), rightSegmentState: .selected, barMetrics: .default)
        self.setDividerImage(dividerImage, forLeftSegmentState: .selected, rightSegmentState: UIControlState(), barMetrics: .default)
        self.setDividerImage(dividerImage, forLeftSegmentState: UIControlState(), rightSegmentState: UIControlState(), barMetrics: .default)
    }
    
    func setupFonts(){
        //let font = UIFont.systemFont(ofSize: 13.0)
        let font = UIFont(name: "Avenir Next", size: 15)

        let normalTextAttributes = [
            NSForegroundColorAttributeName: UIColor.black,
            NSFontAttributeName: font
        ]
        
        self.setTitleTextAttributes(normalTextAttributes as Any as? [AnyHashable : Any] , for: UIControlState())
        self.setTitleTextAttributes(normalTextAttributes as Any as? [AnyHashable : Any], for: .highlighted)
        // self.setTitleTextAttributes(normalTextAttributes, for: .selected)
        self.setTitleTextAttributes(normalTextAttributes as Any as? [AnyHashable : Any] , for: .selected)
    }
    
}
