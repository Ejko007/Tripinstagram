//
//  tripDetailMapPOIListVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

class tripDetailMapPOIListVC: UITableViewController {

    
    @IBOutlet weak var tripDetailMapPOINavigationBar: UINavigationBar!
    @IBOutlet weak var tripDetailMapPOINavigationItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        tripDetailMapPOINavigationBar.barTintColor = UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)
        tripDetailMapPOINavigationBar.isTranslucent = false
        tripDetailMapPOINavigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        tripDetailMapPOINavigationBar.backgroundColor = .white
        tripDetailMapPOINavigationBar.tintColor = .white
        tripDetailMapPOINavigationItem.title = trip_POI_str.uppercased()

        // Create right navigation item - add POI button
        let addPOIBtn = UIBarButtonItem(image: UIImage(named: "add-poi.png"), style: .plain, target: self, action: #selector(addPOI))
        tripDetailMapPOINavigationItem.rightBarButtonItem = addPOIBtn
        addPOIBtn.tintColor = .white

        // Create left navigation item - back button
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back))
        tripDetailMapPOINavigationItem.leftBarButtonItem = backBtn
        backBtn.tintColor = .white

        
        let width = UIScreen.main.bounds.width
        // let height = UIScreen.main.bounds.height

        // allow constraints
        tripDetailMapPOINavigationBar.translatesAutoresizingMaskIntoConstraints = false
       
        // constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[navbar(\(width))]-|",
            options: [],
            metrics: nil, views: ["navbar":tripDetailMapPOINavigationBar]))

        // let h = self.tabBarController?.tabBar.frame.height
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[navbar(60)]",
            options: [],
            metrics: nil, views: ["navbar":tripDetailMapPOINavigationBar]))

        

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // allow edit feature
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }


    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // go back function
    func addPOI(sender: UIBarButtonItem) {
        //push back
        self.dismiss(animated: true, completion: nil)
    }

    // go back function
    func back(sender: UIBarButtonItem) {
        //push back
        tabBarController?.selectedIndex = 0
    }

}
