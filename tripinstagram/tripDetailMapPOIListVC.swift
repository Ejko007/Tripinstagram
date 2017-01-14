//
//  tripDetailMapPOIListVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class tripDetailMapPOIListVC: UITableViewController {

    // arrays to hold information from server
    var poinameArray = [String]()
    var poidescriptionArray = [String]()
    var poidetailsArray = [String]()
    var poilongitudeArray = [String]()
    var poilatitudeArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar title
        self.navigationItem.title = trip_POI_str.uppercased()
        
        // Create right navigation item - add POI button
        let addPOIBtn = UIBarButtonItem(image: UIImage(named: "add-poi.png"), style: .plain, target: self, action: #selector(addPOI))
        self.navigationItem.rightBarButtonItem = addPOIBtn
        self.navigationItem.leftBarButtonItem?.title = update_post_str
        addPOIBtn.tintColor = .white
        
        // load poi records
        let poiQuery = PFQuery(className: "tripsegmentpoi")
        // poiQuery.whereKey("uuid", equalTo: PFUser.current()!.username!)
        poiQuery.findObjectsInBackground(block: {(objects: [PFObject]?, error: Error?) in
            if error == nil {
                // clean up
                self.poinameArray.removeAll(keepingCapacity: false)
                self.poidescriptionArray.removeAll(keepingCapacity: false)
                self.poidetailsArray.removeAll(keepingCapacity: false)
                self.poilongitudeArray.removeAll(keepingCapacity: false)
                self.poilatitudeArray.removeAll(keepingCapacity: false)
                
                // find related objects
                for object in objects! {
                    self.poinameArray.append(object.object(forKey: "poiname") as! String)
                    self.poidescriptionArray.append(object.object(forKey: "poidescription") as! String)
                    self.poidetailsArray.append(object.object(forKey: "poidetails") as! String)
                    
                    let point = object["location"] as! PFGeoPoint
                    self.poilatitudeArray.append("\(point.latitude)")
                    self.poilongitudeArray.append("\(point.longitude)")
                }
            } else {
                print(error!.localizedDescription)
            }
            
            self.tableView.reloadData()
        })

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // allow edit feature
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // delegation settings
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return poinameArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripDetailMapPOIListCell", for: indexPath) as! tripDetailMapPOIListCell
        
        cell.POIName.text = poinameArray[indexPath.row]
        cell.POIName.sizeToFit()
        cell.POIDescription.text = poidescriptionArray[indexPath.row]
        cell.POIDescription.sizeToFit()
        cell.LongtitudeValueLbl.text = poilongitudeArray[indexPath.row]
        cell.LongtitudeValueLbl.sizeToFit()
        cell.LatitudeValueLbl.text = poilatitudeArray[indexPath.row]
        cell.LatitudeValueLbl.sizeToFit()
        cell.POIDescriptionTxtView.text = poidetailsArray[indexPath.row]
        cell.POIDescriptionTxtView.sizeToFit()
        
        // assign index
        cell.showDescriptionBtn.layer.setValue(indexPath, forKey: "index")
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
 
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = indexPath.row
        print("\(row)")
    }
    */
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

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
    
    @IBAction func showDescriptionTapped(_ sender: AnyObject) {
        // call index of button
        let i = sender.layer.value(forKey: "index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i as IndexPath) as! tripDetailMapPOIListCell
        
        // send related data to global variables
        descriptionuuid = cell.POIDescriptionTxtView.text!
        
        // go to comments. present its VC
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "tripDetailMapPOIDescVC") as! tripDetailMapPOIDescVC
        self.navigationController?.pushViewController(destination, animated: true)
        
    }

}
