//
//  UrlBuilder.swift
//  Aminals
//
//  Created by David Rynn on 10/21/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import Foundation

struct UrlBuilder {
    static func buildURL(tracker: PageTracker, searchString: String)-> URL? {
        switch(tracker.currentType) {
        case .cats:
            return URL(string: Constants.baseURL+Constants.giphyKey+Constants.search+"cats"+Constants.offset+"\(tracker.currentOffset)"+Constants.last)
        case .dogs:
            return URL(string: Constants.baseURL+Constants.giphyKey+Constants.search+"dogs"+Constants.offset+"\(tracker.currentOffset)"+Constants.last)
        case .animals:
            return URL(string: Constants.baseURL+Constants.giphyKey+Constants.search+"animals"+Constants.offset+"\(tracker.currentOffset)"+Constants.last)
        case .search:
            return URL(string: Constants.baseURL+Constants.giphyKey+Constants.search+searchString+Constants.offset+"\(tracker.currentOffset)"+Constants.last)

        }
    }
}
