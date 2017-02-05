//
//  tripDetailMapPOIListVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog

class tripDetailMapPOIListVC: UITableViewController {

    // arrays to hold information from server
    var poinameArray = [String]()
    var poidescriptionArray = [String]()
    var poidetailsArray = [String]()
    var poilongitudeArray = [String]()
    var poilatitudeArray = [String]()
    var poiuuidArray = [String]()
    var poitypeArray = [Int]()
    var poiorderArray = [Int]()
    
    // post uuid
    var uuid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "save"), object: nil)
        
        // navigation bar title
        self.navigationItem.title = trip_POI_str.uppercased()
        
        // Create right navigation item - add POI button
        let addPOIBtn = UIBarButtonItem(image: UIImage(named: "add-poi.png"), style: .plain, target: self, action: #selector(addPOI))
        self.navigationItem.rightBarButtonItem = addPOIBtn
        self.navigationItem.leftBarButtonItem?.title = update_post_str
        addPOIBtn.tintColor = .white
        
        // load poi records
        let poiQuery = PFQuery(className: "tripsegmentpoi")
        poiQuery.order(byAscending: "poiorder")
        poiQuery.whereKey("uuid", equalTo: postuuid.last!)
        poiQuery.findObjectsInBackground(block: {(objects: [PFObject]?, error: Error?) in
            if error == nil {
                // clean up
                self.poinameArray.removeAll(keepingCapacity: false)
                self.poidescriptionArray.removeAll(keepingCapacity: false)
                self.poidetailsArray.removeAll(keepingCapacity: false)
                self.poilongitudeArray.removeAll(keepingCapacity: false)
                self.poilatitudeArray.removeAll(keepingCapacity: false)
                self.poiuuidArray.removeAll(keepingCapacity: false)
                self.poitypeArray.removeAll(keepingCapacity: false)
                self.poiorderArray.removeAll(keepingCapacity: false)
                
                // find related objects
                for object in objects! {
                    self.poinameArray.append(object.object(forKey: "poiname") as! String)
                    self.poidescriptionArray.append(object.object(forKey: "poidescription") as! String)
                    self.poidetailsArray.append(object.object(forKey: "poidetails") as! String)
                    self.poiuuidArray.append(object.object(forKey: "poiuuid") as! String)
                    self.poitypeArray.append(object.object(forKey: "poitype") as! Int)
                    self.poiorderArray.append(object.object(forKey: "poiorder") as! Int)
                    
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
        cell.LongtitudeValueLbl.textAlignment = .center
        cell.LatitudeValueLbl.text = poilatitudeArray[indexPath.row]
        cell.LatitudeValueLbl.textAlignment = .center
        cell.POIDescriptionTxtView.text = poidetailsArray[indexPath.row]
        cell.POIDescriptionTxtView.sizeToFit()
        cell.POIUUID.text = poiuuidArray[indexPath.row]
        cell.POIUUID.sizeToFit()
        if poitypeArray[indexPath.row] == 0 {
           cell.POITypeView.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
        } else {
           cell.POITypeView.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
       }
       cell.POIOrderLbl.text = "\(poiorderArray[indexPath.row])"
        
        // assign index
        cell.showDescriptionBtn.layer.setValue(indexPath, forKey: "index")
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // call cell for calling further cell data
       let cell = tableView.cellForRow(at: indexPath) as! tripDetailMapPOIListCell
        
       let delete = UITableViewRowAction(style: .normal, title: "   ") { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
        
        // Delete the row from the data source
        // STEP 1. Delete POI from server
        let poiQuery = PFQuery(className: "tripsegmentpoi")
        poiQuery.whereKey("poiuuid", equalTo: cell.POIUUID.text!)
        poiQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                for object in objects! {
                    object.deleteEventually()
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        
        // close cell
        tableView.setEditing(false, animated: true)
        
        // STEP 2. Delete row from tableView
        self.poinameArray.remove(at: indexPath.row)
        self.poidescriptionArray.remove(at: indexPath.row)
        self.poidetailsArray.remove(at: indexPath.row)
        self.poilongitudeArray.remove(at: indexPath.row)
        self.poilatitudeArray.remove(at: indexPath.row)
        self.poiuuidArray.remove(at: indexPath.row)
        self.poitypeArray.remove(at: indexPath.row)
        self.poiorderArray.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .fade)

        }
        delete.backgroundColor = UIColor(patternImage: UIImage(named: "delete")!)
        
        return [delete]
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

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 190
        return CGFloat(tableView.estimatedRowHeight)
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "tripDetailMapPOIVC") as! tripDetailMapPOIVC

        destination.isNewPOI = false
        
        let row = indexPath.row
        poiuuid.append(poiuuidArray[row])

        self.navigationController?.pushViewController(destination, animated: true)       
    }
    
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    */
    
    // add POI function
    func addPOI(sender: UIBarButtonItem) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "tripDetailMapPOIVC") as! tripDetailMapPOIVC
        destination.isNewPOI = true
        self.navigationController?.pushViewController(destination, animated: true)
        
    }

    // go back function
    func back(sender: UIBarButtonItem) {
        //push back
        tabBarController?.selectedIndex = 0
    }
    
    // refreshing function
    func refresh () {
        // load poi records
        let poiQuery = PFQuery(className: "tripsegmentpoi")
        poiQuery.order(byAscending: "poiorder")
        // poiQuery.whereKey("uuid", equalTo: PFUser.current()!.username!)
        poiQuery.whereKey("uuid", equalTo: postuuid.last!)
        poiQuery.findObjectsInBackground(block: {(objects: [PFObject]?, error: Error?) in
            if error == nil {
                // clean up
                self.poinameArray.removeAll(keepingCapacity: false)
                self.poidescriptionArray.removeAll(keepingCapacity: false)
                self.poidetailsArray.removeAll(keepingCapacity: false)
                self.poilongitudeArray.removeAll(keepingCapacity: false)
                self.poilatitudeArray.removeAll(keepingCapacity: false)
                self.poiuuidArray.removeAll(keepingCapacity: false)
                self.poitypeArray.removeAll(keepingCapacity: false)
                self.poiorderArray.removeAll(keepingCapacity: false)
                
                // find related objects
                for object in objects! {
                    self.poinameArray.append(object.object(forKey: "poiname") as! String)
                    self.poidescriptionArray.append(object.object(forKey: "poidescription") as! String)
                    self.poidetailsArray.append(object.object(forKey: "poidetails") as! String)
                    self.poiuuidArray.append(object.object(forKey: "poiuuid") as! String)
                    self.poitypeArray.append(object.object(forKey: "poitype") as! Int)
                    self.poiorderArray.append(object.object(forKey: "poiorder") as! Int)
                    
                    let point = object["location"] as! PFGeoPoint
                    self.poilatitudeArray.append("\(point.latitude)")
                    self.poilongitudeArray.append("\(point.longitude)")
                }
            } else {
                print(error!.localizedDescription)
            }
            
            let okbtn = DefaultButton(title: ok_str, action: nil)
            let complMenu = PopupDialog(title: annotation_str, message: annotation_save_confirm_str)
            complMenu.addButtons([okbtn])
            self.present(complMenu, animated: true, completion: nil)

            self.tableView.reloadData()
        })
    }

    
    @IBAction func showDescriptionTapped(_ sender: AnyObject) {
        // call index of button
        let i = sender.layer.value(forKey: "index") as! NSIndexPath
        
        // call cell to call further cell data
        let cell = tableView.cellForRow(at: i as IndexPath) as! tripDetailMapPOIListCell
        
        // send related data to global variables
        descriptionuuid = cell.POIDescriptionTxtView.text!
        
        // go to POI comments. present its VC
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "tripDetailMapPOIDescVC") as! tripDetailMapPOIDescVC
        self.navigationController?.pushViewController(destination, animated: true)
    }

}
