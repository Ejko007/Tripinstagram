//
//  SplashVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

import UIKit

/**
 * Snippet from CodeTrench.com
 */
class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        addLogo()
        
        // Show the home screen after a bit. Calls the showSplash() function.
        _ = Timer.scheduledTimer(
            timeInterval: 2.5, target: self, selector: #selector(showSplash), userInfo: nil, repeats: false
        )
    }
    
    /*
     * Gets rid of the status bar
     */
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    /*
     * Shows the app's main home screen.
     * Gets called by the timer in viewDidLoad()
     */
    func showSplash() {
        self.performSegue(withIdentifier: "showApp", sender: self)
    }
    
    /*
     * Adds background image to the splash screen
     */
    func addBackgroundImage() {
        let screenSize: CGRect = UIScreen.main.bounds
        
        let bg = UIImage(named: "launch.png")
        let bgView = UIImageView(image: bg)
        
        bgView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        self.view.addSubview(bgView)
    }
    
    /*
     * Adds logo to splash screen
     */
    func addLogo() {
        let screenSize: CGRect = UIScreen.main.bounds
        
        let logo     = UIImage(named: "Postrip.png")
        let logoView = UIImageView(image: logo)
        
        let w = logo?.size.width
        let h = logo?.size.height
        
        logoView.frame = CGRect(x: (screenSize.width/2) - (w!/2), y: 5, width: w!, height: h!)
        self.view.addSubview(logoView)
    }
}
