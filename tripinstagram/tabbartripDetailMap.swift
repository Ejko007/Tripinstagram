//
//  tabbartripDetailMap.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit



class tabbartripDetailMap: UITabBarController {
    
    var tripuuid = String()

    @IBOutlet weak var tabbarNavigation: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // color of item
        self.tabBar.tintColor = .white
        
        // color of background
        self.tabBar.barTintColor = UIColor(red: 37.0 / 255.0, green: 39.0 / 255.0, blue: 42.0 / 255.0, alpha: 1)
        
        // disable translucent
        self.tabBar.isTranslucent = false
        
        self.tabBarController?.selectedIndex = 0
    }
    
}
