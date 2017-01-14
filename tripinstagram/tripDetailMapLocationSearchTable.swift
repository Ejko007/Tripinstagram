//
//  LocationSearchTable.swift
//  MapKitTutorial
//
//  Created by Robert Chen on 12/28/15.
//  Copyright © 2015 Thorn Technologies. All rights reserved.
//

import UIKit
import MapKit

class tripDetailMapLocationSearchTable : UITableViewController {
    
    var handleMapSearchDelegate: HandleMapSearch? = nil
    var matchingItems:[MKMapItem] = []
    var mapView: MKMapView? = nil
    var searchText = ""
    
    func findMatchingStrings() -> [String] {
        let searchHistory = tripDetailMapSearchHistory.searchHistory
        let filteredResults = searchHistory.filter { term in
            return term.lowercased().contains(searchText.lowercased())
        }
        return filteredResults
    }
    
    func parseAddress(_ selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

extension tripDetailMapLocationSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView,
            let searchBarText = searchController.searchBar.text else { return }
        searchText = searchBarText
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}

extension tripDetailMapLocationSearchTable {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return findMatchingStrings().count
        case 1:
            return matchingItems.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
            switch indexPath.section {
            case 0:
                cell.textLabel?.text = findMatchingStrings()[indexPath.row]
                cell.detailTextLabel?.text = ""
                return cell
            default:
                let selectedItem = matchingItems[indexPath.row].placemark
                cell.textLabel?.text = selectedItem.name
                cell.detailTextLabel?.text = parseAddress(selectedItem)
                return cell
            }
    }
}

extension tripDetailMapLocationSearchTable {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let selectedSearchTerm = findMatchingStrings()[indexPath.row]
            handleMapSearchDelegate?.setSearchBarText(selectedSearchTerm)
        default:
            let selectedItem = matchingItems[indexPath.row].placemark
            handleMapSearchDelegate?.dropPinZoomIn(selectedItem)
            tripDetailMapSearchHistory.appendSearchTerm(searchText)
            dismiss(animated: true, completion: nil)
        }
    }
}
