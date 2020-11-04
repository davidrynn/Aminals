//
//  GYAnimal.swift
//  Aminals
//
//  Created by David Rynn on 9/8/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import UIKit

struct GYAnimal: Decodable {
    let id: String
    let title: String
    let images: GYImageData
    let sourceUrl: String

    enum CodingKeys: String, CodingKey {
        case id, title, images
        case sourceUrl = "url"
    }

}
