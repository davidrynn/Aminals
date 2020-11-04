//
//  GYImageData.swift
//  Aminals
//
//  Created by David Rynn on 9/8/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import Foundation

struct GYImageData: Decodable {

    let original: GYLinkData
    let downsampled: GYLinkData
    
    enum CodingKeys: String, CodingKey {
        case original
        case downsampled = "fixed_width_still"
    }
}
