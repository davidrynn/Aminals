//
//  PageTracker.swift
//  Aminals
//
//  Created by David Rynn on 10/21/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import Foundation

/// Struct keeps track of page values for animal items for loading next batch and also the current animal type selected
struct PageTracker {
    var offsetCats = 0
    var offsetDogs = 0
    var offsetAnimals = 0
    var offsetSearch = 0
    
    var currentType: AnimalType
    
    var currentOffset: Int {
        switch(currentType) {
        case .cats:
            return offsetCats
        case .dogs:
            return offsetDogs
        case .animals:
            return offsetAnimals
        case .search:
            return offsetSearch
        }
    }
    
    mutating func incrementCurrentOffset() {
        switch(currentType) {
        case .cats:
            offsetCats += 25
        case .dogs:
            offsetDogs += 25
        case .animals:
            offsetAnimals += 25
        case .search:
            offsetSearch += 25
        }
    }
    
}
