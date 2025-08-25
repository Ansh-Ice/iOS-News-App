//
//  NewsListView.swift
//  NewsApp
//
//  Created by BMIIT on 18/08/25.
//

import Foundation
import SwiftUI

struct NewsListView: View {
    @State private var news = News(status: "", totalResults: 0, articles: [])
    @State private var selectedCategory = "general"
    @State private var searchText = ""
    @State private var searchSuggestions = ["Apple", "Tesla", "COVID", "Bitcoin", "NASA"]
    @State private var isSearching = false

    let apiKey: String = "2eab5ec0a3574672829a8c6b23d4434f"

    struct Category: Identifiable, Hashable {
        let id = UUID()
        let name: String
        let iconName: String
    }
    
    let categories: [Category] = [
        Category(name: "general", iconName: "newspaper"),
        Category(name: "business", iconName: "briefcase.fill"),
        Category(name: "entertainment", iconName: "tv.fill"),
        Category(name: "health", iconName: "heart.text.square.fill"),
        Category(name: "science", iconName: "atom"),
        Category(name: "sports", iconName: "sportscourt.fill"),
        Category(name: "technology", iconName: "desktopcomputer")
    ]

    var body: some View {
        NavigationStack {
            VStack {
                // Categories horizontal scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(categories) { category in
                            Button {
                                selectedCategory = category.name
                                searchText = ""       // Clear search when selecting category
                                Task { await loadNews() }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: category.iconName)
                                        .font(.subheadline)
                                    Text(category.name.capitalized)
                                        .font(.subheadline)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    selectedCategory == category.name && searchText.isEmpty
                                    ? Color.blue.opacity(0.85)
                                    : Color.gray.opacity(0.2)
                                )
                                .foregroundColor(selectedCategory == category.name && searchText.isEmpty ? .white : .primary)
                                .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }

                // News List with search
                List(news.articles) { article in
                    NavigationLink(value: article.url) {
                        CardView(article: article)
                    }
                    .listRowBackground(Color.clear)
                    .contentShape(Rectangle())
                }
                .listStyle(.plain)
                .refreshable {
                    if searchText.isEmpty {
                        await loadNews()
                    } else {
                        await searchNews(query: searchText)
                    }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search news") {
                    ForEach(searchSuggestions.filter {
                        searchText.isEmpty ? false : $0.lowercased().contains(searchText.lowercased())
                    }, id: \.self) { suggestion in
                        Text(suggestion).searchCompletion(suggestion)
                    }
                }
                .onSubmit(of: .search) {
                    Task {
                        await searchNews(query: searchText)
                    }
                }
                .navigationTitle("Top News")
                .navigationDestination(for: String.self) { url in
                    WebView(url: URL(string: url)!)
                }
            }
            .onAppear {
                Task { await loadNews() }
            }
        }
    }
    
    // Load news by category
    func loadNews() async {
        if let fetched = await News.fetchNews(apiKey: apiKey, category: selectedCategory) {
            news = fetched
        }
    }
    
    // Search news by query
    func searchNews(query: String) async {
        if query.isEmpty {
            await loadNews()
            return
        }
        if let fetched = await News.fetchNewsWithQuery(apiKey: apiKey, query: query) {
            news = fetched
            
            // Add new search term to suggestions (keep max 10)
            if !searchSuggestions.contains(query) {
                searchSuggestions.insert(query, at: 0)
                if searchSuggestions.count > 10 {
                    searchSuggestions.removeLast()
                }
            }
        }
    }
}

//extension News {
//    static func fetchNewsWithQuery(apiKey: String, query: String) async -> News? {
//        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            return nil
//        }
//        let url = "https://newsapi.org/v2/everything?q=\(encodedQuery)&apiKey=\(apiKey)"
//        do {
//            return try await NetworkingManager.shared.request(endpoint: url, responseType: News.self)
//        } catch {
//            print("❌ Search fetch error: \(error)")
//            return nil
//        }
//    }
//}
