//
//  ContentView.swift
//  Notes
//
//  Created by Brett Chapin on 6/12/24.
//

import SwiftUI

struct Home: View {
    
    @State var notes: [Note] = []
    @State var shouldAdd = false
    
    var body: some View {
        NavigationView {
            List(notes) { note in
                Text(note.note)
                    .padding()
            }
            .sheet(isPresented: $shouldAdd, content: {
                AddNoteView()
            })
            .navigationTitle("Notes")
            .navigationBarItems(trailing: Button(action: {
                shouldAdd.toggle()
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
            
            do {
                let notes = try JSONDecoder().decode([Note].self, from: data)
                self.notes = notes
            } catch {
                print(error)
            }
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
