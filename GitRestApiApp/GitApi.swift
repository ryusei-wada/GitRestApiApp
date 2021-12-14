//
//  GitApi.swift
//  GitRestApiApp
//
//  Created by Ryusei Wada on 2021/12/14.
//

import Foundation
import Combine

struct API {
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
