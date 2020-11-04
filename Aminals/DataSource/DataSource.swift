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

    var searchString = ""

    private var tracker = PageTracker(currentType: .animals)
    private var isLoadingPage = false
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
        guard !isLoadingPage else {
            return
        }
        //TODO: Handle Error
        let defaultGiphyData = GYAnimalResponseData(data: [])
        let giphyDataTask = try! fetch(.giphy, defaultValue: defaultGiphyData)

        let defaultTenorValue = TRResponseData(results: [])
        let tenorTask = try! fetch(.tenor, defaultValue: defaultTenorValue)
        isLoadingPage = true
        let combined = Publishers.Zip(giphyDataTask, tenorTask)
        combined
            .handleEvents(receiveOutput: { response in
                self.isLoadingPage = false
                self.tracker.incrementCurrentOffset()
            })
            .sink { gyAnimalData, gifData in
                let giphyAnimals = gyAnimalData.data.map { Animal($0) }
                let tenorAnimals = gifData.results.map { Animal($0) }
                switch(self.tracker.currentType) {
                case .cats:
                    self.cats += giphyAnimals + tenorAnimals
                case .dogs:
                    self.dogs += giphyAnimals + tenorAnimals
                case .animals:
                    self.random += giphyAnimals + tenorAnimals
                case .search:
                    self.search += giphyAnimals + tenorAnimals
                }

            }
            .store(in: &requests)
    }

    // https://www.hackingwithswift.com/plus/networking
    private func fetch<T: Decodable>(_ source: LinkSource, defaultValue: T) throws -> AnyPublisher<T, Never> {
        let decoder = JSONDecoder()
        let url = try UrlBuilder.buildURL(source: source, tracker: tracker, searchString: searchString)
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .replaceError(with: defaultValue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func resetSearch() {
        search = [Animal]()
    }

    private func setCurrentType(_ type: AnimalType) {
        tracker.currentType = type
    }

}
