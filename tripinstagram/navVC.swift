//
//  navVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func apply(gradient colors : [UIColor])
    {
        setBackgroundImage(UINavigationBar.gradient(size: bounds.size, colors: colors), for: .default)
    }
    
    static func gradient(size : CGSize, colors : [UIColor]) -> UIImage?
    {
        // Turn the colors into CGColors
        let cgcolors = colors.map { $0.cgColor }
        
        // Begin the graphics context
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        // If no context was retrieved, then it failed
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // From now on, the context gets ended if any return happens
        defer { UIGraphicsEndImageContext() }
        
        // Create the Coregraphics gradient
        var locations : [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        
        // Draw the gradient
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: 0.0, y: size.height), options: [])
        
        // Generate the image (the defer takes care of closing the context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

class navVC: UINavigationController {
    
    
    

    // default fun
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // color of title at the top in navigation controller
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        // color of buttons in navigation controller
        self.navigationBar.tintColor = .white
        
        // color of background of navigation controller
        self.navigationBar.barTintColor = UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 0.5)
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = .clear
        
        self.navigationBar.apply(gradient: [UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 0), UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)])
        
        // unable translucent
        self.navigationBar.isTranslucent = true
        
    }

    // white status bar function
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
