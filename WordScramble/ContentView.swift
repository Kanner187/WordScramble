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
   @State private var Usedwords = [String]()
   @State private var rootWord = ""
   @State private var newWord = ""
    
    //Mark:- Body
    var body: some View {
        NavigationView{
            VStack(spacing: 10){
                TextField("   Enter new word", text: $newWord , onCommit: addNewWord)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                
                List(Usedwords, id: \.self){
                    Text("\($0)")
                    Image(systemName: "\($0.count).circle.fill")
                }
            }
            
        }
    .navigationBarTitle("\(rootWord)")
    .onAppear(perform: startGame)
    
    }
    
    
    //METHODS
    func addNewWord(){
        let new = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard new.count > 0 else { return }
        Usedwords.insert(new, at: 0)
        newWord = ""
        
    }
    
    func startGame(){
        if let filePath = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let content = try? String(contentsOf: filePath){
                let allWords = content.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Couldn't load start.txt from Bundle")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
