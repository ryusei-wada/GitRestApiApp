//
//  ResultView.swift
//  GitRestApiApp
//
//  Created by Ryusei Wada on 2021/12/14.
//

import SwiftUI
import Combine

enum API {
    static func search(page: Int, perPage: Int, query: String) -> AnyPublisher<[Repository], Error> {
        let url = URL(string: "https://api.github.com/search/repositories?q=\(query)&sort=stars&page=\(page)&per_page=\(perPage)")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode(Result.self, from: $0.data).items }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct Result: Codable {
    let items: [Repository]
}

struct Repository: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let description: String?
    let url: String
    let stargazersCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case url = "html_url"
        case stargazersCount = "stargazers_count"
    }
}

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
                        .font(Font.system(size: 24).bold())
                        .foregroundColor(Color.pink)
                        
                    Text("Description")
                        .fontWeight(.bold)
                        .italic()
                    Text(repository.description ?? "")
                    Text("URL")
                        .fontWeight(.bold)
                        .italic()
                    Text(repository.url)
                    Text("⭐️")
                        .fontWeight(.bold)
                        .italic()
                    Text(" \(repository.stargazersCount)")
                }
            }
        }
        .navigationBarTitle("search query : \(query)")
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
