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
    @State var thumbnail = UIImage(systemName: "photo")!
    @State var loading = true
    let animal: Animal

    var body: some View {
        HStack {
            ZStack {
                ActivityView(animate: $loading, style: .medium).frame(width: 32.0, height: 32.0, alignment: .center)
                Image(uiImage: thumbnail).resizable().frame(width: 32.0, height: 32.0)
            }
            Spacer()
            Text(animal.title)
        }.onAppear {
            loading = true
            DispatchQueue.global(qos: .background).async {
                if let dataUrl = URL(string: animal.smallImageURL), let imageData = try? Data(contentsOf: dataUrl), let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        thumbnail = image
                        loading = false
                    }
                }
            }
        }
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        let animal = Animal(id: "123", imageURL: "nil", smallImageURL: "nil", title: "No Image")
        ListRow(animal: animal)
    }
}
