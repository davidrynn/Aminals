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
        HStack {
          Image(uiImage: self.defaultImage)
            .font(.headline)
          Spacer()
          Text(animal.title)
        }
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
          return Animal(id: animalData.id, imageURL: animalData.images.original.url, smallImageURL: animalData.images.downsampled.url, smallImage: nil, title: animalData.title)
      }
      }
//      .flatMap { (animal) -> AnyPublisher<Animal, Never> in
//        fetchImage(url: URL(string: animal.smallImageURL)!, defaultValue: defaultImage) { image in
//          return Animal(id: animal.id, imageURL: animal.imageURL, smallImageURL: animal.smallImageURL, smallImage: image, title: animal.title)
//        }
//      }
//      .flatMap { animal in
//        fetchImage(url: URL(string: animal.smallImageURL)!, defaultValue: defaultImage) { image in
//          return Animal(id: animal.id, imageURL: animal.imageURL, smallImageURL: animal.smallImageURL, smallImage: image, title: animal.title)
//        }
//      }
      .sink(receiveValue: { animals in
        self.animals = animals
      })
        .store(in: &self.requests)
    }

  }

//  func getAllData(url: URL, defaultValue: AnimalResponseData) -> AnyPublisher<[Animal], Never> {
//    fetch(url, defaultValue: defaultValue)
//      .flatMap { animalResponse in
//        Publishers.Sequence(sequence: animalResponse.data.flatMap { animalData in
//          Animal(id: animalData.id, imageURL: animalData.images.original.url, smallImageURL: animalData.images.downsampled.url, smallImage: nil, title: animalData.title)
//        })
//        .collect()
//        .eraseToAnyPublisher()
//
//    }
////      getIDs(for: type).flatMap { ids in
////          Publishers.Sequence(sequence: ids.map { self.getData(with: $0) })
////              .flatMap { $0 }
////              .collect()
////      }.eraseToAnyPublisher()
//  }

  func fetch(url: URL, completion: @escaping (AnimalResponseData) -> Void) {
      let decoder = JSONDecoder()
         let bogus = AnimalData(id: "123", title: "DefaultData", images: ImageData(original: LinkData(url: ""), downsampled: LinkData(url: "")))

      URLSession.shared.dataTaskPublisher(for: url)
          .retry(1)
          .map(\.data)
          .decode(type: AnimalResponseData.self, decoder: decoder)
          .replaceError(with: AnimalResponseData(data: [bogus]))
          .receive(on: DispatchQueue.main)
          .sink(receiveValue: completion)
          .store(in: &requests)
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

//  func fetch<T: Decodable>(_ url: URL, defaultValue: T) -> AnyPublisher<T, Never> {
//      let decoder = JSONDecoder()
//      return URLSession.shared.dataTaskPublisher(for: url)
//          .retry(1)
//          .map(\.data)
//          .decode(type: T.self, decoder: decoder)
//          .replaceError(with: defaultValue)
//          .receive(on: DispatchQueue.main)
//          .eraseToAnyPublisher()
//  }

//  func fetchImage(url: URL, defaultValue: UIImage) -> AnyPublisher<UIImage, Never> {
//    return URLSession.shared.dataTaskPublisher(for: url)
//            .retry(1)
//      .map { (UIImage(data: $0.data) ?? defaultValue) }
//            .replaceError(with: defaultValue)
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//  }

  func fetchImage(url: URL, defaultValue: UIImage, completion: @escaping (UIImage) -> Void) {
    URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
      .map { (UIImage(data: $0.data) ?? defaultValue) }
            .replaceError(with: defaultValue)
            .receive(on: DispatchQueue.main)
      .sink { value in
          completion(value)
    }
    .store(in: &requests)
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
