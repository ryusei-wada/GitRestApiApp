//
//  ContentView.swift
//  GitRestApiApp
//
//  Created by Ryusei Wada on 2021/12/14.
//

import SwiftUI
import CoreData


struct ContentView: View {
    @State private var query = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                TextField("query", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .submitLabel(.done)
                
                NavigationLink(destination: ResultView(query: query)) {
                    Text("search")
                }
                
                Spacer()
            }.navigationTitle("GitRepoSearch")
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
