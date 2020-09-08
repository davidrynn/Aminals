//
//  Animal.swift
//  Aminals
//
//  Created by David Rynn on 9/8/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import UIKit
import Combine

class Animal: ObservableObject, Identifiable {
  let id: String
  let image: UIImage
  let smallImage: UIImage
  let text: String

  init(id: String, image: UIImage, smallImage: UIImage, text: String) {
    self.image = image
    self.smallImage = smallImage
    self.text = text
    self.id = id
  }
}
