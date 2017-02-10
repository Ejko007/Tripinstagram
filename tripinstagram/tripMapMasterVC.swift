//
//  tripMapMasterVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

class tripMapMasterVC: UIViewController {
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    
    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "tripMapVC") as! tripMapVC
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "itineraryVC") as! itineraryVC
        return secondChildTabVC
    }()

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var segmentedControl: TabySegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a navigation item with a title
        self.navigationItem.title = triproute_menu_str.uppercased()
        
        // add contraints
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints settings
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[segmentcontrol(30)]-5-[mainview]-|",
            options: [],
            metrics: nil, views: ["segmentcontrol":segmentedControl, "mainview": contentView]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[segmentcontrol]-10-|",
            options: [],
            metrics: nil, views: ["segmentcontrol":segmentedControl]))

        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[mainview]-0-|",
            options: [],
            metrics: nil, views: ["mainview":contentView]))
        
        // Add segments
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: map_str, at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: map_itinerary_str, at: 1, animated: false)
        segmentedControl.addTarget(self, action: #selector(selectSegmentInSegmentView(_:)), for: .valueChanged)
        segmentedControl.initUI()
        segmentedControl.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }

    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.firstChildTab.rawValue :
            vc = firstChildTabVC
        case TabIndex.secondChildTab.rawValue :
            vc = secondChildTabVC
        default:
            return nil
        }
        
        return vc
    }
    
    // segment selector for .ValueChanged
    func selectSegmentInSegmentView(_ sender: TabySegmentedControl) {
        //updateView()
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
}
