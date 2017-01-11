//
//  tripsListVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class tripsListVC: UITableViewController, UINavigationBarDelegate {

    // size of screen
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var username = String()
    var uuid = String()
    
    @IBOutlet weak var tripsListNavigation: UINavigationItem!
    
    var dateArray = [Date?]()
    
    let tripListCategoryArray : [String] = ["Detaily","Galerie","Popis","Trasa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 242.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        tripsListNavigation.title = trips_list_str.uppercased()
        
        if revealViewController() != nil {
            let menuBtn = UIBarButtonItem(image: UIImage(named: "menu.png"), style: .plain, target: self.revealViewController(), action: #selector(PBRevealViewController.revealRightView))
            
            revealViewController().rightViewRevealOverdraw = 100
            // revealViewController().rightViewRevealWidth = width - 50
            //revealViewController().rightViewRevealDisplacement = 0
            menuBtn.tintColor = .white
            
            navigationItem.rightBarButtonItem = menuBtn
            view.addGestureRecognizer(revealViewController().panGestureRecognizer)
 
            // Create left navigation item - back button
            let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back))
            navigationItem.leftBarButtonItem = backBtn
            backBtn.tintColor = .white
            
            tripsListNavigation.rightBarButtonItem = menuBtn
            tripsListNavigation.leftBarButtonItem = backBtn
        }
        
        // navigation bar
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.delegate = self
        self.navigationController?.title = trips_list_str.uppercased()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        findTripSegments()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // dismiss expanding menu
        self.tabBarController?.view.subviews.last?.isHidden = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // configureExpandingMenuButton()
        
        self.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return dateArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyy"
        
        return dateformatter.string(from: dateArray[section]!)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripsListCell", for: indexPath) as! tripsListCell

        cell.triplistCategoryLbl.text = tripListCategoryArray[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "tripsListHeaderCell") as! tripsListHeaderCell
        
        header.backgroundColor = UIColor(red: 74 / 255, green: 144 / 255, blue: 226 / 255, alpha: 30 / 100)
        header.textLabel?.tintColor = .black

        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyy"
        header.triplistDateLbl.text = dateformatter.string(from: dateArray[section]!)

        return header
    }

    // select trip category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var nextTVC = UITabBarController()
        
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch indexPath.row {
        case 0: self.performSegue(withIdentifier: "tripDetailMapVC", sender: self)
        case 1: self.performSegue(withIdentifier: "tripDetailMapVC", sender: self)
        case 2: self.performSegue(withIdentifier: "tripDetailMapVC", sender: self)
        case 3: nextTVC = storyBoard.instantiateViewController(withIdentifier: "tabbartripDetailMap") as! tabbartripDetailMap
        
        // set initial tab bar to 0 
        //tabbartripDetailMap
        nextTVC.selectedIndex = 0
        self.present(nextTVC, animated: true, completion: nil)

        default: break
        }
    }

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
    
    // find trip segments
    func findTripSegments () {
        
        let tripsQuery = PFQuery(className: "tripsegment")
        print(postuuid.last!)
        tripsQuery.whereKey("uuid", equalTo: postuuid.last!)
        tripsQuery.addAscendingOrder("tripsegmentDate")
        tripsQuery.findObjectsInBackground (block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clean up
                self.dateArray.removeAll(keepingCapacity: false)
               
                for object in objects! {
                    self.dateArray.append(object.value(forKey: "tripsegmentDate") as! Date?)
                }
            } else {
                print(error!.localizedDescription)
            }
        })
    }

    // go back function
    func back(sender: UIBarButtonItem) {
        //push back
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func unwindToTripsListVC(segue:UIStoryboardSegue) {
    
        //self.dismiss(animated: true, completion: nil)
    }
    
}
