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
    
    @Published var cats = [GYAnimal]()
    @Published var dogs = [GYAnimal]()
    @Published var random = [GYAnimal]()
    @Published var search = [GYAnimal]()
    @Published var isLoadingPage = false
    @Published private var tracker = PageTracker(currentType: .animals)
    var searchString = ""

    var items: [GYAnimal] {
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

    /// Change type of animal for data
    /// - Parameter selection: animal type to change into
    func typeDidChange(selection: AnimalType) {
        setCurrentType(selection)
        if selection == .search { resetSearch()}
        if items.count == 0 {
            fetchData()
        }
    }

    /// Fetches gif data via url session/datapublisher based on current selection
    func fetchData() {
        guard !isLoadingPage, let url = UrlBuilder.buildURL(tracker: tracker, searchString: searchString) else {
            return
        }
        isLoadingPage = true
        let bogus = GYAnimal(id: "123", title: "DefaultData", images: GYImageData(original: GYLinkData(url: ""), downsampled: GYLinkData(url: "")))
        let defaultData = GYAnimalResponseData(data: [bogus])
        URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
            .map(\.data)
            .decode(type: GYAnimalResponseData.self, decoder: JSONDecoder())
            .replaceError(with: defaultData)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                self.isLoadingPage = false
                self.tracker.incrementCurrentOffset()
            })
            .map({ response -> [GYAnimal] in
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
            .store(in: &requests)
    }

    private func resetSearch() {
        search = [GYAnimal]()
    }

    private func setCurrentType(_ type: AnimalType) {
        tracker.currentType = type
    }

}
