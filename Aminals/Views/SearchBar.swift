//
//  SearchBar.swift
//  Aminals
//
//  Created by David Rynn on 10/29/20.
//  Copyright © 2020 David Rynn. All rights reserved.
// https://medium.com/@axelhodler/creating-a-search-bar-for-swiftui-e216fe8c8c7f

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    @State var didCommit: (() -> Void)
    
    var body: some View {
        HStack {
            TextField("Search ...", text: $text) { didChange in
                if didChange {
                    self.isEditing = true
                } else {
                    self.isEditing = false
                }
            } onCommit: {
                didCommit()
            }
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10)
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}
