//
//  AnimalImageView.swift
//  Aminals
//
//  Created by David Rynn on 9/13/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import UIKit
import SwiftUI

struct AnimalImageView: UIViewRepresentable {
  @Binding var image: UIImage

  func makeUIView(context: Context) -> UIImageView {
    let view = UIImageView(frame: .zero)
//    view.contentScaleFactor = 0.5
    view.contentMode = .scaleAspectFit
    return view
  }

  func updateUIView(_ uiView: UIImageView, context: Context) {
    uiView.image = image
//    uiView.contentMode = .scaleAspectFit
    uiView.contentScaleFactor = 0.2
  }
}
