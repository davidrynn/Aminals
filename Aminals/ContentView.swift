//
//  ContentView.swift
//  Aminals
//
//  Created by David Rynn on 9/8/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import Combine
import SwiftUI

struct ContentView: View {
  let defaultImage = UIImage(systemName: "questionmark.square.fill")!
  @State private var requests = Set<AnyCancellable>()
  @State private var animals = [Animal]()
  var body: some View {
    NavigationView {
      List(animals) { animal in
        NavigationLink(destination: AnimalDetailView(imageURL: URL(string: animal.imageURL)!, title: animal.title)) {
            ListRow(animal: animal)
      }
      }
    }
      .navigationBarTitle("Animals")
      .onAppear {
      let url = URL(string: String(Constants.baseURL))!

      let bogus = AnimalData(id: "123", title: "DefaultData", images: ImageData(original: LinkData(url: ""), downsampled: LinkData(url: "")))
      let defaultData = AnimalResponseData(data: [bogus])

      self.fetch(url, defaultValue: defaultData)
        .map { $0.data }
        .map {  $0.flatMap { animalData in
          return Animal(id: animalData.id, imageURL: animalData.images.original.url, smallImageURL: animalData.images.downsampled.url, title: animalData.title)
      }
      }
      .sink(receiveValue: { animals in
        self.animals = animals
      })
        .store(in: &self.requests)
    }

  }

  func fetch(_ url: URL, defaultValue: AnimalResponseData) -> AnyPublisher<AnimalResponseData, Never> {
      let decoder = JSONDecoder()
      return URLSession.shared.dataTaskPublisher(for: url)
          .retry(1)
          .map(\.data)
          .decode(type: AnimalResponseData.self, decoder: decoder)
          .replaceError(with: defaultValue)
          .receive(on: DispatchQueue.main)
          .eraseToAnyPublisher()
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
