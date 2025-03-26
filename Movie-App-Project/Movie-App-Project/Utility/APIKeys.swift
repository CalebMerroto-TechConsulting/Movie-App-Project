//
//  APIKeys.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//



import Foundation

struct APIKeys {
    static var tasteDive: String {
        guard let url = Bundle.main.url(forResource: "APIKeys", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let keys = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let key = keys["tasteDiveAPIKey"] as? String else {
            fatalError("Could not load TasteDive API key from APIKeys.plist")
        }
        return key
    }
    
    static var omdb: String {
        guard let url = Bundle.main.url(forResource: "APIKeys", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let keys = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
              let key = keys["omdbAPIKey"] as? String else {
            fatalError("Could not load OMDB API key from APIKeys.plist")
        }
        return key
    }
}

func tasteDiveURL(_ query: String,_ limit: Int = 20) -> String {
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
