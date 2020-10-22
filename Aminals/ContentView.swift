//
//  ContentView.swift
//  Aminals
//
//  Created by David Rynn on 9/8/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import Combine
import SwiftUI

enum AnimalType: Int {
    case cats = 0, dogs = 1, random = 2
}

struct ContentView: View {
    let defaultImage = UIImage(systemName: "questionmark.square.fill")!
    let imageCache = NSCache<NSString, UIImage>()
    @State private var selection = 0
    @StateObject private var dataSource = DataSource()
    var body: some View {
        NavigationView {
            VStack {
            Picker(selection: $selection, label: Text("What animals would you like to see?")) {
                Text("Cats").tag(0)
                Text("Dogs").tag(1)
                Text("Random").tag(2)
            }
            .onChange(of: selection) { _ in
                guard let type = AnimalType(rawValue: selection) else { return }
                self.dataSource.setCurrentType(type)
                self.dataSource.loadMoreContentIfNeeded(currentItem: self.dataSource.items.first)
                }
                .pickerStyle(SegmentedPickerStyle())

                ScrollView {
                    LazyVStack() {
                        ForEach(dataSource.items) { animal in
                            NavigationLink(destination: AnimalDetailView(imageURL: URL(string: animal.images.original.url)!, title: animal.title)) {
                                ListRow(animal: animal, imageCache: imageCache)
                            }
                            .onAppear {
                                self.dataSource.loadMoreContentIfNeeded(currentItem: animal)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Animals")
        .onAppear {
            dataSource.loadMoreContentIfNeeded(currentItem: dataSource.items.first)
        }
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(dataSource: <#DataSource#>)
//    }
//}
