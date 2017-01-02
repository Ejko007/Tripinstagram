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
    
    @IBOutlet weak var tripsListNavigation: UINavigationBar!
    
    var dateArray = [Date?]()
    
    let tripListCategoryArray : [String] = ["Detaily","Galerie","Popis","Trasa"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        self.tripsListNavigation.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 75)
        self.tripsListNavigation.barTintColor = UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)
        self.tripsListNavigation.isTranslucent = false
        self.tripsListNavigation.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.tripsListNavigation.backgroundColor = .white
        self.tripsListNavigation.tintColor = .white
        self.tripsListNavigation.delegate = self
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = trips_list_str.uppercased()
        
        // Create left and right button for navigation item
        // new back button
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backBtn
        backBtn.tintColor = .white
        
        let spentBtn = UIBarButtonItem(image: UIImage(named: "spent_add.png"), style: .plain, target: self, action: #selector(back))
        navigationItem.rightBarButtonItem = spentBtn
        backBtn.tintColor = .white
        
        // Assign the navigation item to the navigation bar
        self.tripsListNavigation.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        view.frame = CGRect(x: 0, y: 75, width: width, height: height - 75)
        view.addSubview(self.tripsListNavigation)
        

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
    
    // new spent icon is clicked
    func addTapped (sender: UIBarButtonItem) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "spentVC") as! spentVC
        
        // delegate user name to next view controller
        //nextVC.username = self.username
        //nextVC.spentuuid = self.uuid
        nextVC.isNew = true
        
        self.present(nextVC, animated:true, completion:nil)
    }
    
}
