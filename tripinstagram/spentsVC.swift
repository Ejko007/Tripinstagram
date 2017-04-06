//
//  spentsVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse
import PopupDialog

class spentsVC: UITableViewController {
    
    // size of screen
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    struct spent {
        var name = String()
        var description = String()
        var sdate = Date()
        var amount = Double()
        var currency = String()
        var sType = Int()
        var uuid = String()
        var objectId = String()
    }
    
    var spentArrayInitial = [spent]()
    var spentArrayOther = [spent]()
    
    var username = String()
    var uuid = String()
        
    // arrays to hold information from server
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Create a navigation item with a title
        self.navigationItem.title = spents_menu_str.uppercased()
        
        let spentBtn = UIBarButtonItem(image: UIImage(named: "spent_add.png"), style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = spentBtn
        spentBtn.tintColor = .white
        
        // show edit button for current user post only
        if (PFUser.current()?.username == self.username) {
            self.navigationItem.rightBarButtonItems = [spentBtn]
            spentBtn.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItems = []
            spentBtn.isEnabled = false
        }
        
    }
    
     // find post
    func findSpents () {
       
        let spentQuery = PFQuery(className: "tripspents")
        spentQuery.whereKey("uuid", equalTo: postuuid.last!)
        spentQuery.addAscendingOrder("spentDate")
        spentQuery.findObjectsInBackground (block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clean up
                self.spentArrayInitial.removeAll(keepingCapacity: false)
                self.spentArrayOther.removeAll(keepingCapacity: false)
                
                //find related objects
                for object in objects! {
                    
                    // initial arrays settings
                    if object.value(forKey: "spentType") as! Int == 0 {
                        self.spentArrayInitial.append(spent(name: object.value(forKey: "spentName") as! String,
                                                            description: object.value(forKey: "spentDescription") as! String,
                                                            sdate: object.value(forKey: "spentDate") as! Date!,
                                                            amount: object.value(forKey: "spentAmount") as! Double,
                                                            currency: object.value(forKey: "spentCurrency") as! String,
                                                            sType: object.value(forKey: "spentType") as! Int,
                                                            uuid: object.value(forKey: "uuid") as! String,
                                                            objectId: object.value(forKey: "objectId") as! String))
                    } else {
                        self.spentArrayOther.append(spent(name: object.value(forKey: "spentName") as! String,
                                                          description: object.value(forKey: "spentDescription") as! String,
                                                          sdate: object.value(forKey: "spentDate") as! Date!,
                                                          amount: object.value(forKey: "spentAmount") as! Double,
                                                          currency: object.value(forKey: "spentCurrency") as! String,
                                                          sType: object.value(forKey: "spentType") as! Int,
                                                          uuid: object.value(forKey: "uuid") as! String,
                                                          objectId: object.value(forKey: "objectId") as! String))
                    }
                }
                self.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // display spents records
        findSpents()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "spentHeaderCell") as! spentHeaderCell
        
        header.textLabel?.tintColor = .white
        header.spentTypeLbl?.tintColor = .white
        header.spentTypeLbl.textColor = .white
        
        if section == 0 {
            header.spentTypeLbl.text = spent_beginning_str
            header.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
        } else {
            header.spentTypeLbl.text = spent_other_str
            header.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
        }
        return header
    }
    
    // cell editability
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // swipe cell for actions
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // call cell for calling further cell data
        var result = spent()
        var initialSpent = Bool()
        
        if indexPath.section == 0 {
            result = spentArrayInitial[indexPath.row]
            initialSpent = true
        } else {
            result = spentArrayOther[indexPath.row]
            initialSpent = false
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! spentCell
        
        // ACTION 1. Delete
        let delete = UITableViewRowAction(style: .normal, title: "    ") { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
            
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont(name:"Helvetica", size:12)
            
            // STEP 1. Delete spent from server
            let spentQuery = PFQuery(className: "tripspents")
            spentQuery.whereKey("uuid", equalTo: result.uuid)
            spentQuery.whereKey("objectId", equalTo: result.objectId)
            spentQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                if error == nil {
                    for object in objects! {
                        object.deleteEventually()
                    }
                    
                    let okbtn = DefaultButton(title: ok_str, action: nil)
                    let delMenu = PopupDialog(title: delete_str, message: spent_deletion_confirmation_str)
                    delMenu.addButtons([okbtn])
                    self.present(delMenu, animated: true, completion: nil)

                } else {
                    print(error!.localizedDescription)
                }
            })
            
            // STEP 2. Delete row from tableView
            if initialSpent {
                self.spentArrayInitial.remove(at: indexPath.row)
            } else {
                self.spentArrayOther.remove(at: indexPath.row)
            }
             
            // close cell
            tableView.setEditing(false, animated: true)
            
            // reloading data
            tableView.reloadData()
        }
        
        // button background
        delete.backgroundColor = UIColor(patternImage: UIImage(named: "delete.png")!)
        
        // spent belongs to current user
        if self.username == PFUser.current()?.username {
            return [delete]
        } else {
            return []
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var initsectionsNr:Int = 0
        var othersectionsNr:Int = 0
        
        let initialSpents = spentArrayInitial.count
        let otherSpents = spentArrayOther.count
        if initialSpents > 0 {
            initsectionsNr = 1
        }
        if otherSpents > 0 {
            othersectionsNr = 1
        }
        
            return (initsectionsNr + othersectionsNr)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var secStr = String()
        if section == 0 {
            secStr = spent_beginning_str
        } else {
            secStr = spent_other_str
        }
        return secStr
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var nr: Int = 0
        if section == 0 {
            nr = spentArrayInitial.count
        } else {
            nr = spentArrayOther.count
        }
        return nr
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "spentCell", for: indexPath) as! spentCell
        
        if (spentArrayInitial.count != 0) || (spentArrayOther.count != 0) {
            
            // connect objects with our information from array
            let cellTitle = indexPath.section
            if cellTitle == 0 {
                cell.spentNameLbl.text = spentArrayInitial[indexPath.row].name
                cell.spentCurrencyLbl.text = spentArrayInitial[indexPath.row].currency
                cell.spentAmountLbl.text = String(format: "%.2f", spentArrayInitial[indexPath.row].amount)
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "dd.MM.yyy"
                cell.spentDateLbl.text = dateformatter.string(from: spentArrayInitial[indexPath.row].sdate)
                
                // label with rounded cornes for date
                cell.spentDateLbl.layer.masksToBounds = true
                cell.spentDateLbl.layer.cornerRadius = 10
                cell.spentDateLbl.backgroundColor = UIColor(colorLiteralRed: 0.00, green: 0.580, blue: 0.969, alpha: 1.00)
                cell.spentDateLbl.textColor = .white
           } else {
                cell.spentNameLbl.text = spentArrayOther[indexPath.row].name
                cell.spentCurrencyLbl.text = spentArrayOther[indexPath.row].currency
                cell.spentAmountLbl.text = String(format: "%.2f", spentArrayOther[indexPath.row].amount)
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "dd.MM.yyy"
                cell.spentDateLbl.text = dateformatter.string(from: spentArrayOther[indexPath.row].sdate)
                // label with rounded cornes for date
                cell.spentDateLbl.layer.masksToBounds = true
                cell.spentDateLbl.layer.cornerRadius = 10
                cell.spentDateLbl.backgroundColor = UIColor(colorLiteralRed: 1.00, green: 0.361, blue: 0.145, alpha: 1.00)
                cell.spentDateLbl.textColor = .white                
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var result = spent()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = mainStoryboard.instantiateViewController(withIdentifier: "spentVC") as! spentVC
        
        // delegate user name to next view controller
        nextVC.spentuuid = self.uuid
        nextVC.username = self.username
        nextVC.isNew = false
        
        if indexPath.section == 0 {
            result = spentArrayInitial[indexPath.row]
        } else {
            result = spentArrayOther[indexPath.row]
        }
        
        nextVC.spentname = result.name
        nextVC.spentamount = result.amount
        nextVC.spentdescription = result.description
        nextVC.spentcurrency = result.currency
        nextVC.spenttype = result.sType
        nextVC.spentdate = result.sdate
        nextVC.spentuuid = result.uuid
        nextVC.spentobjectId = result.objectId
        
        self.navigationController!.pushViewController(nextVC, animated: true)        
    }
    
    // show/dismiss expanding menu
    override func viewWillDisappear(_ animated: Bool) {
        // dismiss expanding menu
        // self.tabBarController?.view.subviews.last?.isHidden = false
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
        nextVC.username = self.username
        nextVC.spentuuid = self.uuid
        nextVC.isNew = true
        
        self.navigationController!.pushViewController(nextVC, animated: true)
    }

}
