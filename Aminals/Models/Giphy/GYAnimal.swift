//
//  GYAnimal.swift
//  Aminals
//
//  Created by David Rynn on 9/8/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import UIKit

struct GYAnimal: Decodable, Identifiable {
    let id: String
    let title: String
    let images: GYImageData

    var formattedTitle: String {
        let text = title.lowercased()
        var components = text.components(separatedBy: " ")
        if components.last == "gif" {
            components = components.dropLast()
        }
        if let first = components.first {
            let firstLetter = first.prefix(1).capitalized
            let newFirst = firstLetter + first.dropFirst()
            components[0] = newFirst
        }
        return components.joined(separator: " ")
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
