//
//  AddNoteView.swift
//  Notes
//
//  Created by Brett Chapin on 6/12/24.
//

import SwiftUI

struct AddNoteView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var text = ""
    
    var body: some View {
        HStack {
            TextField("Write a note...", text: $text)
                .padding(.horizontal, 16)
                .clipped()
            
            Button(action: postNote) {
                Text("Add")
            }
            .padding(8)
        }
    }
    
    private func postNote() {
        let params = ["note": text] as [String: Any]
        let url = URL(string: "http://localhost:3000/notes")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch {
            print(error)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] {
                    print(json)
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
        self.text = ""
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddNoteView()
}
