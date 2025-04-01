//
//  APIKeys.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import Foundation

struct APIKeys {
    // Load and cache keys from APIKeys.plist only once.
    private static let keys: [String: String] = {
        guard let url = Bundle.main.url(forResource: "APIKeys", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let keys = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: String] else {
            fatalError("Could not load APIKeys.plist")
        }
        return keys
    }()
    
    static var tasteDive: String { keys["tasteDiveAPIKey"]! }
    
    static var omdb: String { keys["omdbAPIKey"]! }
}

func tasteDiveURL(_ query: String, _ limit: Int = 20) -> String {
    let apiKey = APIKeys.tasteDive
    let baseURL = "https://tastedive.com/api/similar?q=movie:"
    let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
    return "\(baseURL)\(encodedQuery)&type=movie&info=0&limit=\(limit)&k=\(apiKey)"
}

func OMDBURL(_ title: String) -> String {
    let apiKey = APIKeys.omdb
    let baseURL = "https://www.omdbapi.com/"
    let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? title
    return "\(baseURL)?apikey=\(apiKey)&t=\(encodedTitle)"
}
