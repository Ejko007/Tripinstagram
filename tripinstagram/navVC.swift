//
//  navVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit

class navVC: UINavigationController {

    // default fun
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // color of title at the top in navigation controller
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        // color of buttons in navigation controller
        self.navigationBar.tintColor = .white
        
        // color of background of navigation controller
        self.navigationBar.barTintColor = UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)
        
        // unable translucent
        self.navigationBar.isTranslucent = false
        
    }

    // white status bar function
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
