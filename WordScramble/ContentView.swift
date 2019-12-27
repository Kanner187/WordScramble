//
//  ContentView.swift
//  WordScramble
//
//  Created by Levit Kanner on 31/10/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    //Mark:- Properties
   @State private var usedWords = [String]()
   @State private var rootWord = ""
   @State private var newWord = ""
   @State private var showingAlert = false
   @State private var alertMessage = ""
   @State private var alertTitle = ""
   @State private var score = 0
    
    
    //Mark:- Body
    var body: some View {
        NavigationView{
            VStack(spacing: 5){
                TextField("   Enter new word", text: $newWord , onCommit: addNewWord)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                
                List(usedWords, id: \.self){ word in
                    GeometryReader{geometry in
                        HStack{
                            Text("\(word)")
                                .offset(x: geometry.frame(in: .global).midY / 14)
                            Spacer()
                            Image(systemName: "\(word.count).circle.fill")
                                .foregroundColor(Color(red: Double(geometry.frame(in: .global).midY / 51 ) / Double(word.count), green: Double(geometry.frame(in: .global).midY / 50 ) / Double(word.count * 4) , blue: Double(word.count / 2)))
                        }
                            
                        
                        .accessibilityElement(children: .ignore)
                        .accessibility(label: Text("\(word) has \(word.count) letters"))
                    }
                    
                    
                    
                }
                
                Text("Score: \(score)")
                    .font(.headline)
            }
            .navigationBarTitle("\(rootWord)")
            .onAppear(perform: startGame)
            .alert(isPresented: $showingAlert) { () -> Alert in
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Okay")))
            }
            .navigationBarItems(trailing: Button(action: startGame, label: {
                Image(systemName: "arrow.clockwise")
                Text("New Word")
            }))
        }
    }
    
    
    //METHODS
    func addNewWord(){
        let new = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard new.count > 0 else { return }
       
        
        guard isOriginal(word: new) else {
            configureAlert(title: "Word used already ", message: "Words can't be repeated")
            return
        }
        guard isPossible(word: new) else {
            configureAlert(title: "Word invalid", message: "Words must be from the root word")
            return
        }
        
        guard isAWord(word: new) else {
            configureAlert(title: "Word doesn't exit", message: "Word invalid")
            return
        }
        
        guard isNotRootWord(word: new) else{
            configureAlert(title: "That's the root Word!", message: "Can not use the root word")
            return
        }
        
        usedWords.insert(new, at: 0)
        score += (new.count * usedWords.count)
        newWord = ""
        
    }
    
    func startGame(){
        if let filePath = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let content = try? String(contentsOf: filePath){
                let allWords = content.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords = [String]()
                score = 0
                return
            }
        }
        fatalError("Couldn't load start.txt from Bundle")
    }
    
    //Validation
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool{
        var temp = rootWord
        
        for letter in word {
            if let position = temp.firstIndex(of: letter){
                temp.remove(at: position)
            }else{
                return false
            }
        }
        return true
    }
    
    
    func isAWord(word: String) -> Bool{
        if word.count < 3{
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misSpelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misSpelledRange.location == NSNotFound
    }
    
    func isNotRootWord(word: String) -> Bool {
        if word == rootWord{
            return false
        }
        return true
    }
    
    func configureAlert(title: String , message: String){
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
