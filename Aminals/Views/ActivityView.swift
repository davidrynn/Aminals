//
//  ActivityView.swift
//  Aminals
//
//  Created by David Rynn on 9/13/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import UIKit
import SwiftUI

struct ActivityView: UIViewRepresentable {

    @Binding var animate: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityView>) {
        animate ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
