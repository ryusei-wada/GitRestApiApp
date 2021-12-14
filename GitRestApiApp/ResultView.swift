//
//  ResultView.swift
//  GitRestApiApp
//
//  Created by Ryusei Wada on 2021/12/14.
//

import SwiftUI
import Combine

struct ResultView: View {
    @State private var repositories: [Repository] = []
    @State private var subscriptions = Set<AnyCancellable>()
    @State private var showingAlert = false
    @State private var errorMessage = ""
    let query : String
    
    var body: some View {
        VStack {
            List(repositories) { repository in
                VStack(alignment: .leading) {
                    Text(repository.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color.pink)
                        
                    Text("Description")
                        .font(.headline)
                        .italic()
                    Text(repository.description ?? "")
                        .font(.body)
                    Text("URL")
                        .font(.headline)
                        .italic()
                    Text(repository.url)
                        .font(.body)
                    Text("⭐️")
                        .font(.headline)
                        .italic()
                    Text(" \(repository.stargazersCount)")
                        .font(.body)
                }
            }
        }
        .navigationBarTitle("query : \(query)")
        .onAppear {
            API.search(page: 1, perPage: 30, query: query)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        self.showingAlert = true
                        self.errorMessage = error.localizedDescription
                    }
                }, receiveValue: { repositories in
                    self.repositories = repositories
                })
                .store(in: &self.subscriptions)
        }
        .alert(isPresented: self.$showingAlert) {
            Alert(
                title: Text("Error"),
                message: Text(self.errorMessage),
                dismissButton: .default(Text("Close")))
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(query: "swift")
    }
}
