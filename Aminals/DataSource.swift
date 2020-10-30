//
//  DataSource.swift
//  Aminals
//
//  Created by David Rynn on 10/21/20.
//  Copyright © 2020 David Rynn. All rights reserved.
// https://www.appcoda.com/swiftui-search-bar/

import Foundation
import Combine
import SwiftUI

class DataSource: ObservableObject {
    
    @Published var cats = [Animal]()
    @Published var dogs = [Animal]()
    @Published var random = [Animal]()
    @Published var search = [Animal]()
    @Published var isLoadingPage = false
    @Published private var tracker = PageTracker(currentType: .animals)
    var searchString = ""

    var items: [Animal] {
        switch (tracker.currentType) {
        case .cats:
            return cats
        case .dogs:
            return dogs
        case .animals:
            return random
        case .search:
            return search
        }
    }
    private var requests = Set<AnyCancellable>()
    
    init() {
        setCurrentType(.animals)
        fetchData()
    }
    
    private func setCurrentType(_ type: AnimalType) {
        tracker.currentType = type
    }
    
    func typeDidChange(selection: AnimalType) {
        setCurrentType(selection)
        if selection == .search { resetSearch()}
        if items.count == 0 {
            fetchData()
        }
    }

    private func resetSearch() {
        search = [Animal]()
    }

    func fetchData() {
        guard !isLoadingPage, let url = UrlBuilder.buildURL(tracker: tracker, searchString: searchString) else {
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
                self.tracker.incrementCurrentOffset()
            })
            .map({ response -> [Animal] in
                switch(self.tracker.currentType) {
                case .cats:
                    return self.cats + response.data
                case .dogs:
                    return self.dogs + response.data
                case .animals:
                    return self.random + response.data
                case .search:
                    return self.search + response.data
                }
            })
            .sink(receiveValue: { animals in
                switch(self.tracker.currentType) {
                case .cats:
                    self.cats = animals
                case .dogs:
                    self.dogs = animals
                case .animals:
                    self.random = animals
                case .search:
                    self.search = animals
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
