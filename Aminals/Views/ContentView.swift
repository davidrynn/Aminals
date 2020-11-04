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
    @State private var showSearchBar = false
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selection, label: Text("What animals would you like to see?")) {
                    Text("Animals").tag(0)
                    Text("Cats").tag(1)
                    Text("Dogs").tag(2)
                    Text("Search").tag(3)
                }
                .onChange(of: selection) { _ in
                    let type = AnimalType(value: selection)
                    if selection == 3 {
                        showSearchBar = true
                        dataSource.searchString = searchText
                        return
                    }
                    showSearchBar = false
                    self.dataSource.typeDidChange(selection: type)
                }
                .pickerStyle(SegmentedPickerStyle())
                if (showSearchBar) {
                    SearchBar(text: $searchText, didCommit: {
                        self.dataSource.searchString = searchText
                        self.dataSource.typeDidChange(selection: .search)
                    })
                }
                
                ScrollView {
                    LazyVStack() {
                        ForEach(dataSource.items) { animal in
                            NavigationLink(destination: AnimalDetailView(imageURL: URL(string: animal.gifURL), title: animal.formattedTitle, source: animal.source, sourceUrl: URL(string: animal.sourceURL))) {
                                ListRow(animal: animal, imageCache: imageCache)
                            }
                            .onAppear {
                                if willfinishScrolling(current: animal) {
                                    dataSource.fetchData()
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

    /// Used for determining when scrolling is about to reach the end of the currently loaded contect - absent ScrollView delegates in SwiftUI
    /// - Parameter current: animal at the index where the scroll is ending - to determing the index.
    /// - Returns: A bool that indicates scrolling has reached the threshold for the end of content
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let dataSource = DataSource()
        ContentView(dataSource: dataSource )
    }
}
