//
//  Animal.swift
//  Aminals
//
//  Created by David Rynn on 11/3/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import Foundation

struct Animal: Identifiable {
    let id: String
    let title: String
    let gifURL: String
    let imageURL: String

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

    init(_ data: GYAnimal) {
        self.id = data.id
        self.title = data.title
        self.gifURL = data.images.original.url
        self.imageURL = data.images.downsampled.url
    }

    init(_ data: TRResult) {
        self.id = data.id
        self.title = data.itemurl.getTenorTitleFromUrl()
        self.gifURL = data.media.first?.gif.url ?? ""
        self.imageURL = data.media.first?.gif.preview ?? ""
    }
    
}
