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
    @State var showAlert = false
    @State var deleteItem: Note?
    
    var body: some View {
        NavigationView {
            List(notes) { note in
                Text(note.note)
                    .onLongPressGesture(perform: {
                        showAlert.toggle()
                        deleteItem = note
                    })
                    .padding()
            }
            .sheet(isPresented: $shouldAdd, onDismiss: {
                fetchNotes()
            }, content: {
                AddNoteView()
            })
            .sheet(isPresented: $shouldAdd, content: {
                AddNoteView()
            })
            .alert(isPresented: $showAlert, content: {
                alert
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
    
    var alert: Alert {
        Alert(title: Text("Delete"), 
              message: Text("Are you sure you want to delete this note?"),
              primaryButton: .destructive(Text("Delete"), action: deleteNote),
              secondaryButton: .cancel())
    }
    
    private func fetchNotes() {
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
    
    private func deleteNote() {
        guard let id = deleteItem?.id else { return }
        
        let url = URL(string: "http://localhost:3000/notes/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        deleteItem = nil
        fetchNotes()
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
