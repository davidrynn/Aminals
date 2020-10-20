//
//  ListRow.swift
//  Aminals
//
//  Created by David Rynn on 10/19/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import SwiftUI
import Combine

struct ListRow: View {
    let animal: Animal
    var body: some View {
        HStack {
            URLImage(url: animal.smallImageURL)
                .font(.headline)
            Spacer()
            Text(animal.title)
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        let animal = Animal(id: "123", imageURL: "nil", smallImageURL: "nil", title: "No Image")
        ListRow(animal: animal)
    }
}

struct URLImage: View {

    @ObservedObject private var imageLoader = ImageLoader()

    var placeholder: Image

    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        self.imageLoader.load(url: url)
    }

    var body: some View {
        if let uiImage = self.imageLoader.downloadedImage {
            return Image(uiImage: uiImage)
        } else {
            return placeholder
        }
    }

}


class ImageLoader: ObservableObject {

    var downloadedImage: UIImage?
    var didChange = PassthroughSubject<ImageLoader?, Never>() {
        didSet {
            print("updated image")
        }
    }

    func load(url: String) {

        guard let imageURL = URL(string: url) else {
            fatalError("ImageURL is not correct!")
        }

        URLSession.shared.dataTask(with: imageURL) { data, response, error in

            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.didChange.send(nil)
                }
                return
            }

            self.downloadedImage = UIImage.gifImageWithData(data)
            DispatchQueue.main.async {
                self.didChange.send(self)
            }

        }.resume()

    }


}
