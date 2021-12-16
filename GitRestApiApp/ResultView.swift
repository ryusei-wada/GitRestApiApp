//
//  ResultView.swift
//  GitRestApiApp
//
//  Created by Ryusei Wada on 2021/12/14.
//

import SwiftUI
import Combine

struct ResultView: View {
    /// 検索結果格納用配列
    @State private var repositories: [Repository] = []
    /// キャンセル用トークン
    @State private var cancellables = Set<AnyCancellable>()
    /// アラート表示フラグ
    @State private var showingAlert = false
    /// アラート表示用エラーメッセージ
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
            // search() -> AnyPublisher<[Repository],Error>
            let publisher = API.search(page: 1, perPage: 30, query: query)

            let subscriber = Subscribers.Sink<[Repository], Error>(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        // 失敗時
                        self.showingAlert = true
                        self.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { repositories in
                    self.repositories = repositories
                })
            
            subscriber.store(in: &self.cancellables)
            
            publisher.subscribe(subscriber)
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
        ResultView(query: "java")
    }
}
