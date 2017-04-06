//
//  currenciesTVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit
import PopupDialog

protocol CurrenciesPopoverDelegate: class {
    func updateCurrencyCode(withCountries countries: [countryInfo])
}

class currenciesTVC: UITableViewController {
    
    var countries = IsoCountries.allCountries
    var subcountries = [IsoCountryInfo]()
    
    weak var delegate: CurrenciesPopoverDelegate?
    
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
    var selectedCurrencyCode:String? {
        didSet {
            if let currencyCode = selectedCountryCode {
                selectedCountryIndex = countries.index(where: { (cntry: IsoCountryInfo) -> Bool in
                    cntry.currency == currencyCode
                })
            }
        }
    }
    
    var selectedCountryIndex:Int?
    var selectedCountries = [countryInfo]()
    var currencyList = [Currency]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelection = false
        
        currencyList = getCurrencyList(referenceCurrency: "USD")
        
        subcountries.removeAll(keepingCapacity: false)
        for country in countries {
            for currency in currencyList {
                if country.currency.uppercased() == currency.name.uppercased() {
                    subcountries.append(country)
                    break
                }
            }
        }
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate?.updateCurrencyCode(withCountries: selectedCountries)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subcountries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCountry", for: indexPath) as! countriesCell
        
        cell.countryImg.image = UIImage(named: subcountries[indexPath.row].alpha2)
        cell.countryNameLbl.text = subcountries[indexPath.row].name
        cell.countryCodeLbl.text = subcountries[indexPath.row].alpha2 + " (" + currency_code_str + ": " + subcountries[indexPath.row].currency + ")"
        
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
            
            selectedCountry = subcountries[indexPath.row].name
            selectedCountryCode = subcountries[indexPath.row].alpha2
            let myCountryInfo = countryInfo.init(name: selectedCountry!, code: selectedCountryCode!)
            selectedCountries.append(myCountryInfo)
 
            delegate?.updateCurrencyCode(withCountries: selectedCountries)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            
            selectedCountry = subcountries[indexPath.row].name
            let index = selectedCountries.index(where: { (myCountryInfo: countryInfo) -> Bool in
                myCountryInfo.name == selectedCountry
            })
            selectedCountries.remove(at: index!)
            
        }
    }
    
}

