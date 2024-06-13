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
    @State var isEditMode: EditMode = .inactive
    @State var updateNote: String = ""
    @State var updateNoteId: String = ""
    
    var body: some View {
        NavigationView {
            List(notes) { note in
                if isEditMode == .inactive {
                    Text(note.note)
                        .onLongPressGesture(perform: {
                            showAlert.toggle()
                            deleteItem = note
                        })
                        .padding()
                } else {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.yellow)
                        
                        Text(note.note)
                            .padding()
                    }
                    .onTapGesture {
                        updateNote = note.note
                        updateNoteId = note.id
                        shouldAdd.toggle()
                    }
                }
            }
            .sheet(isPresented: $shouldAdd, onDismiss: {
                fetchNotes()
            }, content: {
                if isEditMode == .active {
                    UpdateNoteView(text: $updateNote, noteId: $updateNoteId)
                } else {
                    AddNoteView()
                }
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
            .navigationBarItems(leading: Button(action: {
                if isEditMode == .inactive {
                    isEditMode = .active
                } else {
                    isEditMode = .inactive
                }
            }, label: {
                if isEditMode == .inactive {
                    Text("Edit")
                } else {
                    Text("Done")
                }
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
        
        if isEditMode == .active {
            isEditMode = .inactive
        }
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
