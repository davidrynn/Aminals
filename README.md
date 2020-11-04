# Aminals
Side-project using SwiftUI and Combine to get animal gifs and present them.
Used combines DataTaskPublisher to asynchronously load data from multiple sources and update state on views.
Main views used SwiftUI with some necessary customization for sharing and gif images.
Currently loads from Giphy and Tenor.  Potentially will add from Reddit and Imgur.

# Installing
You will need to create and add a 'Constants.swift' file with api keys for Giphy and/or Tenor.

`struct Constants {
    static let giphyKey = "your giphy key here"
    static let tenorKey = "your tenor key here"
}`
