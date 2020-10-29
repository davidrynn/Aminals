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
    @StateObject var dataSource: DataSource
    @State private var selection = 0
    @State var currentAnimalId: String?
    var body: some View {
        NavigationView {
            ScrollViewReader {  scrollView in
                VStack {
                    Picker(selection: $selection, label: Text("What animals would you like to see?")) {
                        Text("Animals").tag(0)
                        Text("Cats").tag(1)
                        Text("Dogs").tag(2)
                    }
                    .onChange(of: selection) { _ in
                        guard let type = AnimalType(rawValue: selection) else { return }
                        self.dataSource.typeDidChange(currentItemId: currentAnimalId, selection: type)
//                        print("Current index: " + String(self.dataSource.getCurrentIndex()))
                        scrollView.scrollTo(15)
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    ScrollView {
                        LazyVStack() {
                            ForEach(dataSource.items) { animal in
                                NavigationLink(destination: AnimalDetailView(imageURL: URL(string: animal.images.original.url)!, title: animal.title)) {
                                    ListRow(animal: animal, imageCache: imageCache)
                                }
                                .onAppear {
                                    if willfinishScrolling(current: animal) {
                                        dataSource.fetchData()
                                        currentAnimalId = animal.id
                                    }

                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Animals")
            }
        }
        .onAppear {
            setNavigationBarAppearance()
        }
    }

    private func willfinishScrolling(current: Animal) -> Bool {
        let thresholdIndex = dataSource.items.index(dataSource.items.endIndex, offsetBy: -5)
        if let currentIndex = dataSource.items.firstIndex(where: { $0.id == current.id }) {
            if (Int(currentIndex) == Int(thresholdIndex)) {
                return true
            }
        }
        return false
    }

    private func setNavigationBarAppearance() {
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
