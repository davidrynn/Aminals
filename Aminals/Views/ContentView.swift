//
//  ContentView.swift
//  Aminals
//
//  Created by David Rynn on 9/8/20.
//  Copyright © 2020 David Rynn. All rights reserved.
//

import Combine
import SwiftUI

struct ContentView: View {
    let defaultImage = UIImage(systemName: "questionmark.square.fill")!
    let imageCache = NSCache<NSString, UIImage>()
    @State private var selection = 0
    @StateObject private var dataSource = DataSource()
    @State private var isFirstAppearance = true
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selection, label: Text("What animals would you like to see?")) {
                    Text("Animals").tag(0)
                    Text("Cats").tag(1)
                    Text("Dogs").tag(2)
                }
                .onChange(of: selection) { _ in
                    print("Selection: \(selection)")
                    guard let type = AnimalType(rawValue: selection) else { return }
                    print(type)
                    self.dataSource.loadMoreContentIfNeeded(currentItem: self.dataSource.items.first, selection: type)
                }
                .pickerStyle(SegmentedPickerStyle())

                ScrollView {
                    LazyVStack() {
                        ForEach(dataSource.items) { animal in
                            NavigationLink(destination: AnimalDetailView(imageURL: URL(string: animal.images.original.url)!, title: animal.title)) {
                                ListRow(animal: animal, imageCache: imageCache)
                            }
                            .onAppear {
                                let thresholdIndex = dataSource.items.index(dataSource.items.endIndex, offsetBy: -5)
                                if let currentIndex = dataSource.items.firstIndex(where: { $0.id == animal.id }) {
                                    if (Int(currentIndex) == Int(thresholdIndex)) {
                                        self.dataSource.fetchData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Animals")
        }
        .onAppear {
            setNavigationBarAppearance()
        }
    }
    mutating func setDidAppear(){
        isFirstAppearance = false
    }

    func setNavigationBarAppearance() {
        let design = UIFontDescriptor.SystemDesign.rounded
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle)
                                         .withDesign(design)!
        let font = UIFont.init(descriptor: descriptor, size: 48)
        UINavigationBar.appearance().largeTitleTextAttributes = [.font : font]
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(dataSource: <#DataSource#>)
//    }
//}
