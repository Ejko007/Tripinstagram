//
//  tripDetailMapSearchHistory.swift
//  MapKitTutorial
//
//  Created by Robert Chen on 6/1/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import Foundation

struct tripDetailMapSearchHistory {
    static let searchHistoryArrayKey = "searchHistoryArrayKey"

    static var searchHistory: [String] {
        let defaults = UserDefaults.standard
        guard let searchHistoryArray: [String] = defaults.array(forKey: searchHistoryArrayKey) as? [String] else { return [] }
        return Array(Set(searchHistoryArray))
    }
    
    static func appendSearchTerm(_ searchString: String) {
        var searchHistoryArray = tripDetailMapSearchHistory.searchHistory
        searchHistoryArray.append(searchString)
        let defaults = UserDefaults.standard
        defaults.set(searchHistoryArray, forKey: searchHistoryArrayKey)
        defaults.synchronize()
    }

}
