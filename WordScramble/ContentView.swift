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
    }
    
    //METHODS
    func addNewWord(){
        let new = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard new.count > 0 else { return }
        Usedwords.insert(new, at: 0)
        newWord = ""
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
