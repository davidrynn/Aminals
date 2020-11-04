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

    /// Change type of animal for data
    /// - Parameter selection: animal type to change into
    func typeDidChange(selection: AnimalType) {
        setCurrentType(selection)
        if selection == .search { resetSearch()}
        if items.count == 0 {
            fetchData()
        }
    }

    func fetchData() {
        guard !isLoadingPage else {
            return
        }
        let giphyDataTask = fetchGiphyData()
        let tenorTask = tenorDataTask()
        isLoadingPage = true
        let combined = Publishers.Zip(giphyDataTask, tenorTask)
        combined
            .handleEvents(receiveOutput: { response in
                self.isLoadingPage = false
                self.tracker.incrementCurrentOffset()
            })
            .sink { gyAnimalData, gifData in
                let giphyAnimals = gyAnimalData.map { Animal($0) }
                let tenorAnimals = gifData.map { Animal($0) }
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

    func tenorDataTask() -> AnyPublisher<[TRResult], Never> {
        let decoder = JSONDecoder()
        let defaultValue = TRResponseData(results: [])
        guard let url = UrlBuilder.buildTenorURL(tracker: tracker, searchString: searchString) else {
            fatalError("invalid tenor url")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
            .map(\.data)
            .decode(type: TRResponseData.self, decoder: decoder)
            .replaceError(with: defaultValue)
            .receive(on: DispatchQueue.main)
            .map({ response -> [TRResult] in
                response.results
            })
            .eraseToAnyPublisher()
    }

    /// Fetches gif data via url session/datapublisher based on current selection
    func fetchGiphyData() -> AnyPublisher<[GYAnimal], Never> {
        let bogus = GYAnimal(id: "123", title: "No image found", images: GYImageData(original: GYLinkData(url: ""), downsampled: GYLinkData(url: "")))
        guard let url = UrlBuilder.buildGiphyURL(tracker: tracker, searchString: searchString) else {
            fatalError("invalid giphy url")
        }
        let defaultData = GYAnimalResponseData(data: [bogus])
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
            .map(\.data)
            .decode(type: GYAnimalResponseData.self, decoder: JSONDecoder())
            .replaceError(with: defaultData)
            .receive(on: DispatchQueue.main)
            .map({ response -> [GYAnimal] in
                response.data
            })
            .eraseToAnyPublisher()
    }

    private func resetSearch() {
        search = [Animal]()
    }

    private func setCurrentType(_ type: AnimalType) {
        tracker.currentType = type
    }

}
