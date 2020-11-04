//
//  UrlBuilder.swift
//  Aminals
//
//  Created by David Rynn on 10/21/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import Foundation

struct UrlBuilder {
    static func buildGiphyURL(tracker: PageTracker, searchString: String)-> URL? {
        let giphyBase = "https://api.giphy.com/v1/gifs/search?api_key="
        let search = "&q="
        let limit = "&limit=25"
        let offset = "&offset="
        let last = "&rating=g&lang=en"
        let type = tracker.currentType
        if type == .search {
            return URL(string: giphyBase+Constants.giphyKey+search+searchString+limit+offset+"\(tracker.currentOffset)"+last)
        }
        return URL(string: giphyBase+Constants.giphyKey+search+String(describing: type)+limit+offset+"\(tracker.currentOffset)"+last)
    }

    static func buildTenorURL(tracker: PageTracker, searchString: String)-> URL? {
        let base = "https://api.tenor.com/v1/search?q="
        let key = "&key="
        let limit = "&limit=25"
        let offset = "&pos="
        let type = tracker.currentType
        if type == .search {
            return URL(string: base+searchString+key+Constants.tenorKey+limit+offset+"\(tracker.currentOffset)")
        }
        return URL(string: base+String(describing: type)+key+Constants.tenorKey+limit+offset+"\(tracker.currentOffset)")
    }
}
