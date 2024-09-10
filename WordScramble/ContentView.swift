//
//  ContentView.swift
//  WordScramble
//
//  Created by Izabela Marcinkowska on 2024-09-10.
//

import SwiftUI

struct ContentView: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]
    var body: some View {
        VStack {
            List {
                ForEach(0..<5) {
                    Text("Dynamic row \($0)")
                }
                Text("Static one")
                    .listStyle(.grouped)
            }
            List {
                ForEach(people, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
