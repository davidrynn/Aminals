//
//  AnimalDetailView.swift
//  Aminals
//
//  Created by David Rynn on 9/12/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import SwiftUI
import Combine

struct AnimalDetailView: View {
  let imageURL: URL
  let title: String
  let defaultImage = UIImage(systemName: "questionmark.square.fill")!
  let isPreview: Bool
  @State private var requests = Set<AnyCancellable>()
  @State var image: UIImage = UIImage()
  @State var loading = true
  var body: some View {
    ZStack {
      ActivityView(animate: $loading, style: .large)
      ZStack {
        VStack {
          Text(title)
          AnimalImageView(image: self.$image)
        }
      }
      .padding(.horizontal, 50)
    }
    .onAppear {
      if self.isPreview {
        self.image = self.defaultImage
        self.loading = false
      }
      else {
        self.fetchImageData(url: self.imageURL)
          .sink { data in
            self.image = UIImage.gifImageWithData(data) ?? self.defaultImage
            self.loading = false
        }
        .store(in: &self.requests)
      }
    }
  }

  init(imageURL: URL, title: String) {
    self.imageURL = imageURL
    self.title = title
    self.isPreview = false
  }

  init() {
    self.imageURL = URL(string: "https:www.google.com")!
    self.title = "Test Title For Preview"
    self.isPreview = true
  }

  func fetchImageData(url: URL) -> AnyPublisher<Data, Never> {
    return URLSession.shared.dataTaskPublisher(for: url)
      .retry(1)
      .map { $0.data }
      .replaceError(with: Data())
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }
}

struct AnimalDetailView_Previews: PreviewProvider {
  static var previews: some View {
    AnimalDetailView()
  }
}
