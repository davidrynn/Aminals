//
//  DataSource.swift
//  Aminals
//
//  Created by David Rynn on 10/21/20.
//  Copyright © 2020 David Rynn. All rights reserved.
// https://www.donnywals.com/implementing-an-infinite-scrolling-list-with-swiftui-and-combine/

import Foundation
import Combine

class DataSource: ObservableObject {

    @Published var cats = [Animal]()
    @Published var dogs = [Animal]()
    @Published var random = [Animal]()
    @Published var isLoadingPage = false
    var items: [Animal] {
        switch (tracker.currentType) {
        case .cats:
            return cats
        case .dogs:
            return dogs
        case .random:
            return random
        }
    }
    private var requests = Set<AnyCancellable>()
    private var tracker = PageTracker()
    private var shouldIncrement = false

    init() {
        shouldIncrement = true
        loadMoreContent()
    }

    func setCurrentType(_ type: AnimalType) {
        tracker.currentType = type
    }

    func loadMoreContentIfNeeded(currentItem item: Animal?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        shouldIncrement = true
        let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
        print("current threshold = \(thresholdIndex)")
        let currentIndex = items.firstIndex(where: { $0.id == item.id })
        print("currentIndex = " + currentIndex.debugDescription)
        if currentIndex == thresholdIndex {
            loadMoreContent()
        }
    }

    private func loadMoreContent() {
        guard !isLoadingPage, let url = UrlBuilder.buildURL(tracker: tracker) else {
            return
        }

        isLoadingPage = true
        let bogus = Animal(id: "123", title: "DefaultData", images: ImageData(original: LinkData(url: ""), downsampled: LinkData(url: "")))
        let defaultData = AnimalResponseData(data: [bogus])
        URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
            .map(\.data)
            .decode(type: AnimalResponseData.self, decoder: JSONDecoder())
            .replaceError(with: defaultData)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.isLoadingPage = false
                if self.shouldIncrement {
                    self.tracker.setCurrentIncrement()
                }
            })
            .map({ response -> [Animal] in
                switch(self.tracker.currentType) {
                case .cats:
                    return self.cats + response.data
                case .dogs:
                    return self.dogs + response.data
                case .random:
                    return self.random + response.data
                }
            })
            .sink(receiveValue: { animals in
                switch(self.tracker.currentType) {
                case .cats:
                    self.cats = animals
                case .dogs:
                    self.dogs = animals
                case .random:
                    self.random = animals
                }
            })
//            .catch({ _ in Just(self.items) })
            .store(in: &requests)
    }
}

/*
 private func loadImages() {
     guard let type = AnimalType(rawValue: selection), let url = UrlBuilder.buildURL(animalType: type) else { return }

     let bogus = Animal(id: "123", title: "DefaultData", images: ImageData(original: LinkData(url: ""), downsampled: LinkData(url: "")))
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

 private func fetch(_ url: URL, defaultValue: AnimalResponseData) -> AnyPublisher<AnimalResponseData, Never> {
     let decoder = JSONDecoder()
     return URLSession.shared.dataTaskPublisher(for: url)
         .retry(1)
         .map(\.data)
         .decode(type: AnimalResponseData.self, decoder: decoder)
         .replaceError(with: defaultValue)
         .receive(on: DispatchQueue.main)
         .eraseToAnyPublisher()
 }
 */
