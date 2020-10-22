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
    @State var thumbnail = UIImage()
    @State var loading = true
    let animal: Animal
    let imageCache: NSCache<NSString, UIImage>
    private let imageHeight: CGFloat = 60.0
//Animal(id: animalData.id, imageURL: animalData.images.original.url, smallImageURL: animalData.images.downsampled.url, title: animalData.title)
    var body: some View {
        HStack {
            ZStack {
                ActivityView(animate: $loading, style: .large).frame(width: imageHeight, height: imageHeight, alignment: .center)
                Image(uiImage: thumbnail).resizable().frame(width: imageHeight, height: imageHeight)
            }
            Spacer()
            Text(animal.title)
        }.onAppear {
            loading = true
            if let cacheImage = imageCache.object(forKey: animal.images.downsampled.url as NSString) {
                DispatchQueue.main.async {
                    loading = false
                    thumbnail = cacheImage
                }
            } else {
                DispatchQueue.global(qos: .background).async {
                    if let dataUrl = URL(string: animal.images.downsampled.url), let imageData = try? Data(contentsOf: dataUrl), let image = UIImage(data: imageData) {
                        imageCache.setObject(image, forKey: animal.images.downsampled.url as NSString)
                        DispatchQueue.main.async {
                            thumbnail = image
                            loading = false
                        }
                    } else {
                        DispatchQueue.main.async {
                            thumbnail = UIImage(systemName: "photo")!
                        }
                    }
                }
            }
        }
    }
}

//struct ListRow_Previews: PreviewProvider {
//    static var previews: some View {
//        let animal = Animal(id: "123", imageURL: "nil", smallImageURL: "nil", title: "No Image")
//        ListRow(animal: animal, imageCache: NSCache<NSString, UIImage>())
//    }
//}
