//
//  ContentView.swift
//  Notes
//
//  Created by Brett Chapin on 6/12/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            List(0..<10) { i in
                Text("We are at \(i)")
                    .padding()
            }
            .navigationTitle("Notes")
            .navigationBarItems(trailing: Button(action: {
                print("Add a note")
            }, label: {
                Text("Add")
            }))
        }
        .onAppear {
            fetchNotes()
        }
    }
    
    func fetchNotes() {
        let url = URL(string: "http://localhost:3000/notes")!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            print(String(data: data, encoding: .utf8))
        }
        
        task.resume()
    }
}

struct Note: Identifiable, Codable {
    var id: String { _id }
    var _id: String
    var note: String
    
    
}

#Preview {
    Home()
}
