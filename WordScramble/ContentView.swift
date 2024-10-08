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
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var points = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
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
            .toolbar{
                ToolbarItem(placement: .bottomBar) {
                    Button("Another word") {
                        startGame()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Text("Points for this word: \(points)")
                }
            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("Ok") {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    func addNewWord () {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else { return }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        guard isLongEnough(word: answer) else {
            wordError(title: "Word too short", message: "Word must be at least 3 letters.")
            return
        }
        addPoints(word: answer)
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
    }
    func startGame() {
        usedWords = []
        points = 0
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
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func isLongEnough (word: String) -> Bool {
        word.count > 2
    }
    
    func addPoints (word: String) -> Void {
        points += 1
        points += word.count
        if word.count > 5 {
            points += 2
        }
    }

    
}

#Preview {
    ContentView()
}
