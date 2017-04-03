//
//  countriesTVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit
import PopupDialog

protocol CountriesPopoverDelegate: class {
    func updateCountriesFlags(withCountries countries: [countryInfo])
}

struct countryInfo {
    var name = String()
    var code = String()
}

class countriesTVC: UITableViewController {    
    
    var countries = IsoCountries.allCountries
    
    weak var delegate: CountriesPopoverDelegate?
    
    var selectedCountry:String? {
        didSet {
            if let country = selectedCountry {
                selectedCountryIndex = countries.index(where: { (cntry: IsoCountryInfo) -> Bool in
                    cntry.name == country
                })
            }
        }
    }
    var selectedCountryCode:String? {
        didSet {
            if let countryCode = selectedCountryCode {
                selectedCountryIndex = countries.index(where: { (cntry: IsoCountryInfo) -> Bool in
                    cntry.alpha2 == countryCode
                })
            }
        }
    }

    var selectedCountryIndex:Int?
    var selectedCountries = [countryInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelection = true
        self.navigationItem.title = countries_str
        self.navigationItem.leftBarButtonItem?.title = back_str
        self.navigationItem.rightBarButtonItem?.title = done_str

        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller./Users/ejko/Desktop/XCode10/tripinstagram/tripinstagram/Base.lproj/Main.storyboard
        // self.navigationItem.rightBarButtonItem = btnDone
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.updateCountriesFlags(withCountries: selectedCountries)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            return countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCountry", for: indexPath) as! countriesCell
        
        cell.countryImg.image = UIImage(named: countries[indexPath.row].alpha2)
        cell.countryNameLbl.text = countries[indexPath.row].name
        cell.countryCodeLbl.text = countries[indexPath.row].alpha2

        // Configure the cell...
        if indexPath.row == selectedCountryIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            
            selectedCountry = countries[indexPath.row].name
            selectedCountryCode = countries[indexPath.row].alpha2
            let myCountryInfo = countryInfo.init(name: selectedCountry!, code: selectedCountryCode!)
            selectedCountries.append(myCountryInfo)
            
         }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            
            selectedCountry = countries[indexPath.row].name
            let index = selectedCountries.index(where: { (myCountryInfo: countryInfo) -> Bool in
                myCountryInfo.name == selectedCountry
            })
            selectedCountries.remove(at: index!)
            
        }
    }
    
    
    @IBAction func cancelBtn_tapped(_ sender: UIBarButtonItem) {
        
        // remove all selected countries flags
        selectedCountries.removeAll(keepingCapacity: false)
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtn_tapped(_ sender: UIBarButtonItem) {
        
        if selectedCountries.count > 7 {
            let okbtn = DefaultButton(title: ok_str, action: nil)
            let complMenu = PopupDialog(title: countries_str, message: countries_max_str)
            complMenu.addButtons([okbtn])
            self.present(complMenu, animated: true, completion: nil)
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

