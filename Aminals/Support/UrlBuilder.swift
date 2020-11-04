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
        let base: String
        let end: String
        switch source {
        case .giphy:
            base = "https://api.giphy.com/v1/gifs/search?api_key=\(Constants.giphyKey)&q="
            end = "&limit=25&offset=\(tracker.currentOffset)&rating=g&lang=en"
        case .tenor:
            base = "https://api.tenor.com/v1/search?q="
            end = "&key=\(Constants.tenorKey)&limit=25&pos=\(tracker.currentOffset)"
        }
        let type = tracker.currentType
        if type == .search {
            guard let searchUrl = URL(string: base+searchString+end) else { throw GifError.badUrl}
            return searchUrl
        }
        guard let url =  URL(string: base+String(describing: type)+end) else {
            throw GifError.badUrl
        }
        return url
    }
}
