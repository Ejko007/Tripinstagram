//
//  TimeFrameVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit

protocol TimeFrameDelegate {
    func didSelectDateRange (range:GLCalendarDateRange)
}

class TimeFrameVC: UIViewController, UINavigationBarDelegate, GLCalendarViewDelegate {
    
    @IBOutlet weak var calendarView: GLCalendarView!
    
    var timeFrameDelegate:TimeFrameDelegate? = nil
    var timeFrame:GLCalendarDateRange? = nil
    var rangeUnderEdit:GLCalendarDateRange? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd.MM.yyy"
        //calendarView.firstDate = dateFormatter.date(from: "01.01.2000")
        // calendarView.lastDate = dateFormatter.date(from: "31.12.2020")
        
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRect(x:0, y:0, width:self.view.frame.size.width, height:75)) // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.barTintColor = UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)
        navigationBar.isTranslucent = false
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        navigationBar.backgroundColor = UIColor.white
        navigationBar.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = choose_data_range_str.uppercased()
        
        // Create left and right button for navigation item
        // new back button
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backBtn
        let acceptBtn = UIBarButtonItem(image: UIImage(named: "accept.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(acceptBtn_clicked))
        navigationItem.rightBarButtonItem = acceptBtn
        let deleteBtn = UIBarButtonItem(image: UIImage(named: "cancel.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(deleteBtn_clicked))
        navigationItem.rightBarButtonItem = deleteBtn
        
        backBtn.tintColor = .white
        acceptBtn.tintColor = .white
        deleteBtn.tintColor = .white
        
        navigationItem.rightBarButtonItems = [acceptBtn,deleteBtn]
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
       
        self.calendarView.delegate = self
        self.calendarView.showMagnifier = true
        
        calendarView.frame = CGRect(x: 0, y: 75, width: width, height: height - 75)
        GLCalendarView.appearance().rowHeight = 50
        GLCalendarView.appearance().padding = 6
                
    }
    
    // accept time range button clicked
    func acceptBtn_clicked(_ sender: UIBarButtonItem) {
        if let selectedTimeframe = timeFrame {
            
            if timeFrameDelegate != nil {
                timeFrameDelegate?.didSelectDateRange(range: selectedTimeframe)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // delete time range button clicked
    func deleteBtn_clicked(_ sender: UIBarButtonItem) {
        if self.rangeUnderEdit != nil {
            self.calendarView.removeRange(self.rangeUnderEdit!)
        }
    }
    
    
    // go back function
    func back(_ sender: UIBarButtonItem) {
        
        //push back
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let today = Date()
        
        let beginDate = GLDateUtils.date(byAddingDays: 0, to: today as Date!)
        let endDate = GLDateUtils.date(byAddingDays: 0, to: today as Date!)
        
        let range = GLCalendarDateRange(begin: beginDate, end: endDate)
        range?.backgroundColor = UIColor.lightGray
        range?.editable = true
        calendarView.ranges = [range!]
        
        calendarView.reload()
        
        DispatchQueue.main.async {
            self.calendarView.scroll(to: self.calendarView.lastDate, animated: false)
        }        
        
    }
    
    func calenderView (_ calendarView: GLCalendarView!, beginToEdit range: GLCalendarDateRange!) {
        self.rangeUnderEdit = range
    }

    func calenderView(_ calendarView: GLCalendarView!, finishEdit range: GLCalendarDateRange!, continueEditing: Bool) {
        self.rangeUnderEdit = nil
    }
    
    func calenderView(_ calendarView: GLCalendarView!, canAddRangeWithBegin beginDate: Date!) -> Bool {
        return true
    }
    
    func calenderView(_ calendarView: GLCalendarView!, rangeToAddWithBegin beginDate: Date!) -> GLCalendarDateRange! {
        let endDate = GLDateUtils.date(byAddingDays: 0, to: beginDate)
        let range = GLCalendarDateRange(begin: beginDate, end: endDate)
        range?.backgroundColor = UIColor.lightGray
        range?.editable = true
        
        return range
        
    }
    
    func calenderView(_ calendarView: GLCalendarView!, beginDate canAddRangeWithBeginDate: Date!) -> Bool {
        return true
    }
    
    
    
    func calenderView(_ calendarView: GLCalendarView!, canUpdate range: GLCalendarDateRange!, toBegin beginDate: Date!, end endDate: Date!) -> Bool {
        return true
    }
    
    func calenderView(_ calendarView: GLCalendarView!, didUpdate range: GLCalendarDateRange!, toBegin beginDate: Date!, end endDate: Date!) {
        timeFrame = range
    }
    
}
