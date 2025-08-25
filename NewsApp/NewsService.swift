//
//  NewsService.swift
//  NewsApp
//
//  Created by BMIIT on 18/08/25.
//

import Foundation

// News+API.swift

import Foundation

extension News {
    static func fetchNews(apiKey: String, category: String) async -> News? {
        let url = "https://newsapi.org/v2/top-headlines?category=\(category)&apiKey=\(apiKey)"
        do {
            return try await NetworkingManager.shared.request(endpoint: url, responseType: News.self)
        } catch {
            print("❌ Fetch error: \(error)")
            return nil
        }
    }

    static func fetchNewsWithQuery(apiKey: String, query: String) async -> News? {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        let url = "https://newsapi.org/v2/everything?q=\(encodedQuery)&apiKey=\(apiKey)"
        do {
            return try await NetworkingManager.shared.request(endpoint: url, responseType: News.self)
        } catch {
            print("❌ Search fetch error: \(error)")
            return nil
        }
    }
}

