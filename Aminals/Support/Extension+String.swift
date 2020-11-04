//
//  Extension+String.swift
//  Aminals
//
//  Created by David Rynn on 11/3/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    func getTenorTitleFromUrl() -> String {
        var edited = self
        if let range = self.range(of: "https://tenor.com/view/") {
           edited.removeSubrange(range)
        }
        var array = edited.components(separatedBy: "-")
        let indexMax = array.count - 1
        if indexMax > 1, array[indexMax - 1] == "gif" {
            array.remove(at: indexMax)
            array.remove(at: indexMax - 1)
        }
        return array.joined(separator: " ")

    }
}
