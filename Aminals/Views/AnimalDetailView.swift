//
//  AnimalDetailView.swift
//  Aminals
//
//  Created by David Rynn on 9/12/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import SwiftUI
import Combine

struct AnimalDetailView: View {
    let imageURL: URL?
    let title: String
    let defaultImage = UIImage(systemName: "questionmark.square.fill")!
    let isPreview: Bool
    let sourceUrl: URL?
    let source: LinkSource
    var sourceString: String {
        return source.rawValue.lowercased().capitalizingFirstLetter()
    }
    
    @State private var requests = Set<AnyCancellable>()
    @State var image: UIImage = UIImage()
    @State var imageData: Data = Data()
    @State var loading = true
    @State var error = false
    
    var body: some View {
        ZStack {
            if error {
                Text("Error loading image")
            } else {
                ActivityView(animate: $loading, style: .large)
                VStack(spacing: 60) {
                    Text(title)
                    AnimalImageView(image: self.$image).fixedSize()
                    if let url = sourceUrl {
                        Link(sourceString, destination: url)
                    }
                }
                .padding(.horizontal, 50)
            }
        }
        .navigationBarItems(trailing:
                              Button(action: {
                                presentShareSheet()
                              }) {
                                Image(systemName: "square.and.arrow.up").imageScale(.large)
                              }
        )
        .onAppear {
            if self.isPreview {
                self.image = self.defaultImage
                self.loading = false
            }
            else {
                guard let url = self.imageURL else {
                    self.error = true
                    return }
                self.fetchImageData(url: url)
                    .sink { data in
                        self.imageData = data
                        self.image = UIImage.gifImageWithData(data) ?? self.defaultImage
                        self.loading = false
                    }
                    .store(in: &self.requests)
            }
        }
    }
    
    init(imageURL: URL?, title: String, source: LinkSource, sourceUrl: URL?) {
        self.imageURL = imageURL
        self.title = title
        self.isPreview = false
        self.source = source
        self.sourceUrl = sourceUrl
    }

    /// For use by preview only
    init() {
        self.imageURL = URL(string: "https:www.google.com")!
        self.title = "Test Title For Preview"
        self.isPreview = true
        self.source = .giphy
        self.sourceUrl = URL(string: "")
    }
    
    func presentShareSheet() {
        let av = UIActivityViewController(activityItems: [imageData], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
    func fetchImageData(url: URL) -> AnyPublisher<Data, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
            .map { $0.data }
            .replaceError(with: Data())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct AnimalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalDetailView()
    }
}
