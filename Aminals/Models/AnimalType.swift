//
//  AnimalType.swift
//  Aminals
//
//  Created by David Rynn on 10/26/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

enum AnimalType: CustomStringConvertible {
    case animals, cats, dogs, search

    var description: String {
        switch(self) {
        case .animals:
            return "animals"
        case .cats:
            return "cats"
        case .dogs:
            return "dogs"
        case .search:
            return "search"
        }
    }

    init(value: Int) {
        switch(value) {
        case 0:
            self = .animals
        case 1:
            self = .cats
        case 2:
            self = .dogs
        case 3:
            self = .search
        default:
            self = .animals
        }
    }
}
