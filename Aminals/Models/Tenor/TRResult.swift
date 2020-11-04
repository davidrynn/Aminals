//
//  TRResult.swift
//  Aminals
//
//  Created by David Rynn on 11/3/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import Foundation

struct TRResult: Decodable {
    let media: [TRMedia]
    let title: String
    let itemurl: String
    let id: String
}
