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
    let animal: GYAnimal
    let imageCache: NSCache<NSString, UIImage>
    private let imageHeight: CGFloat = 60.0
    var body: some View {
        HStack() {
            ZStack() {
                ActivityView(animate: $loading, style: .large).frame(width: imageHeight, height: imageHeight, alignment: .center)
                Image(uiImage: thumbnail).resizable().frame(width: imageHeight, height: imageHeight)
            }
            Text(animal.formattedTitle)
            Spacer()
        }
        .padding(10)
        .onAppear {
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

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        let linkData = GYLinkData(url: "")
        let imageData = GYImageData(original: linkData, downsampled: linkData)
        let animal = GYAnimal(id: "123", title: "No image", images: imageData)
        ListRow(animal: animal, imageCache: NSCache<NSString, UIImage>())
    }
}
