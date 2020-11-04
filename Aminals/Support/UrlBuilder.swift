//
//  UrlBuilder.swift
//  Aminals
//
//  Created by David Rynn on 10/21/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import Foundation

enum GifError: Error {
    case badUrl
}

struct UrlBuilder {
    static func buildURL(source: LinkSource, tracker: PageTracker, searchString: String) throws -> URL {
        let searchWord = tracker.currentType == .search ? searchString : String(describing: tracker.currentType)
        var components = URLComponents()
        components.scheme = "https"
        switch source {
        case .giphy:
            components.host = "api.giphy.com"
            components.path = "/v1/gifs/search"
            components.queryItems = [
                URLQueryItem(name: "api_key", value: Constants.giphyKey),
                URLQueryItem(name: "q", value: searchWord),
                URLQueryItem(name: "limit", value: "25"),
                URLQueryItem(name: "offset", value: "\(tracker.currentOffset)"),
                URLQueryItem(name: "rating", value: "g"),
                URLQueryItem(name: "lang", value: Locale.current.languageCode)
            ]
        case .tenor:
            components.host = "api.tenor.com"
            components.path = "/v1/search"
            components.queryItems = [
                URLQueryItem(name: "key", value: Constants.tenorKey),
                URLQueryItem(name: "q", value: searchWord),
                URLQueryItem(name: "limit", value: "25"),
                URLQueryItem(name: "pos", value: "\(tracker.currentOffset)"),
            ]
        }
        guard let url =  components.url else {
            throw GifError.badUrl
        }
        return url
    }
}
