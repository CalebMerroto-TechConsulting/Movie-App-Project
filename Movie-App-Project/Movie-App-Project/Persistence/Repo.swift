//
//  RepoProtocol.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//


//
//  Repo.swift
//  PokemonMVVMR
//
//  Created by Caleb Merroto on 3/18/25.
//
import Foundation

protocol RepoProtocol {
    func fetch<T: Decodable>(url: String) async throws -> T
}

class Repo: RepoProtocol {
    static let shared = Repo() // Singleton
    
    private let api: NetworkService
    private var cache: [String: Data] = [:] // Store raw JSON Data
    
    private let cacheFileName = "./RepoCache.json"
    
    private init(api: NetworkService = NetworkLayer()) {
        self.api = api
        loadCache() // Load cache when initialized
    }
    
    func fetch<T: Decodable>(url: String) async throws -> T {
        if let cachedData = cache[url] {
//            print("Using Cached Data for URL: \(url)")
            return try JSONDecoder().decode(T.self, from: cachedData)
        }

//        print("Fetching from API: \(url)")
        let data = try await api.get(url: url)
        cache[url] = data
        saveCache() // Save updated cache
        
        return try JSONDecoder().decode(T.self, from: data!)
    }
    
    // MARK: - Persistence
    
    private func saveCache() {
        do {
            let fileURL = getCacheFileURL()
            let jsonData = try JSONEncoder().encode(cache) // Convert to JSON format
            try jsonData.write(to: fileURL)
//            print("Cache saved successfully")
        } catch {
//            print("Failed to save cache: \(error)")
        }
    }
    
    private func loadCache() {
        let fileURL = getCacheFileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            cache = try JSONDecoder().decode([String: Data].self, from: data)
//            print("Cache loaded successfully")
        } catch {
//            print("No existing cache found or failed to load: \(error)")
        }
    }
    
    private func getCacheFileURL() -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        print(directory.appendingPathComponent(cacheFileName))
        return directory.appendingPathComponent(cacheFileName)
    }
}
