//
//  ContentView.swift
//  WordScramble
//
//  Created by Izabela Marcinkowska on 2024-09-10.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String] ()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                }
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
        }
    }
    func addNewWord () {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    func startGame() {
        // Find the url for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // split the strig into an array
                let allWords = startWords.components(separatedBy: "\n")
                // pick one random word or use silkworm
                rootWord = allWords.randomElement() ?? "silkworm"
                // if we are here everything worked, so we exit
                return
            }
        }
        // if we are here something went wrong
        fatalError("Could not load start.txt from a bundle")
    }

    
    
}

#Preview {
    ContentView()
}
