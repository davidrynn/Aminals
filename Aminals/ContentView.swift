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
  @State private var requests = Set<AnyCancellable>()
  @State private var animals = [Animal]()
  var body: some View {
    NavigationView {
      List(animals) { animal in
        HStack {
          Image(uiImage: animal.smallImage)
            .font(.headline)
          Spacer()
          Text(animal.text)
        }
      }
      .navigationBarTitle("Animals")
    }.onAppear {
      let newAnimal = Animal(id: "123", image: UIImage(systemName: "heart.fill")!, smallImage: UIImage(systemName: "heart.fill")!, text: "Test Image")
      self.animals.append(newAnimal)
    }

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
