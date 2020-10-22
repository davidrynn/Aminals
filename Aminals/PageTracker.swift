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
    var offsetRandom = 0

    var currentType: AnimalType = .cats

    var currentOffset: Int {
        switch(currentType) {
        case .cats:
            return offsetCats
        case .dogs:
            return offsetDogs
        case .random:
            return offsetRandom
        }
    }

    mutating func setCurrentIncrement() {
        switch(currentType) {
        case .cats:
            offsetCats += 25
        case .dogs:
            offsetDogs += 25
        case .random:
            offsetRandom += 25
        }
    }
}
