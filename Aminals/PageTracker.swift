//
//  PageTracker.swift
//  Aminals
//
//  Created by David Rynn on 10/21/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import Foundation

struct PageTracker {
    var offsetCats = 0
    var offsetDogs = 0
    var offsetAnimals = 0

    var catsId = ""
    var dogsId = ""
    var animalsId = ""

    var currentType: AnimalType

    var currentOffset: Int {
        switch(currentType) {
        case .cats:
            return offsetCats
        case .dogs:
            return offsetDogs
        case .animals:
            return offsetAnimals
        }
    }

    var currentId: String {
        switch(currentType) {
        case .cats:
            return catsId
        case .dogs:
            return dogsId
        case .animals:
            return animalsId
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
        }
    }

    mutating func setId(_ id: String) {
        switch(currentType) {
        case .cats:
            catsId = id
        case .dogs:
            dogsId = id
        case .animals:
            animalsId = id
        }
    }
    
}
