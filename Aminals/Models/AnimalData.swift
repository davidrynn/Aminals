//
//  AnimalData.swift
//  Aminals
//
//  Created by David Rynn on 9/8/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import UIKit

struct AnimalData: Decodable, Identifiable {
  let id: String
  let title: String
  let images: ImageData
}
