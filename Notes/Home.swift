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
    }
}

#Preview {
    Home()
}
