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
  let imageURL: String
  var smallImageURL: String
  var smallImage: UIImage?
  let title: String

  init(id: String, imageURL: String, smallImageURL: String, smallImage: UIImage? = nil, title: String) {
    self.imageURL = imageURL
    self.smallImageURL = smallImageURL
    self.smallImage = smallImage
    self.title = title
    self.id = id
  }
}
