//
//  quantityLevelTVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

protocol QuantityLevelsPopoverDelegate: class {
    func updateLevelsNr(withQuantity quantity: Int)
}

class quantityLevelTVC: UITableViewController {
    
    var quantities = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    weak var delegate: QuantityLevelsPopoverDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return quantities.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellLevelsNr", for: indexPath)
            cell.textLabel?.text = "\(quantities[indexPath.row])"
            cell.textLabel?.textAlignment = .center
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let selectedQty = quantities[indexPath.row]
            delegate?.updateLevelsNr(withQuantity: selectedQty)
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}


// delegate for UITextField
extension quantityLevelTVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let qty = textField.text {
            delegate?.updateLevelsNr(withQuantity: Int(qty)!)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        return true
    }
}
