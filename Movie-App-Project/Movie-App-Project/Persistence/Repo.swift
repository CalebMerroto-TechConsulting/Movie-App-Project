//
//  RepoProtocol.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import Foundation

protocol RepoProtocol {
    func fetch<T: Decodable>(url: String) async throws -> T
}

class Repo: RepoProtocol {
    static let shared = Repo() // Singleton
    
    private var api: NetworkService
    private var cache: [String: Data] = [:] // Store raw JSON Data
    private let cacheFileName = "RepoCache.json"
    private let decoder = JSONDecoder()
    
    func setNetwork(api: NetworkService) {
        self.api = api
    }
    
    private init(api: NetworkService = NetworkLayer()) {
        self.api = api
        loadCache()
    }
    
    func fetch<T: Decodable>(url: String) async throws -> T {
        // Return cached data if available.
        if let cachedData = cache[url] {
            return try decoder.decode(T.self, from: cachedData)
        }
        
        // Fetch data from network.
        guard let data = try await api.get(url: url) else {
            throw APIError.noData
        }
        
        // Cache the new data and persist.
        cache[url] = data
        saveCache()
        
        return try decoder.decode(T.self, from: data)
    }
    
    private func saveCache() {
        do {
            let fileURL = getCacheFileURL()
            let jsonData = try JSONEncoder().encode(cache)
            try jsonData.write(to: fileURL)
        } catch {
            print("Failed to save cache: \(error)")
        }
    }
    
    private func loadCache() {
        let fileURL = getCacheFileURL()
        do {
            let data = try Data(contentsOf: fileURL)
            cache = try JSONDecoder().decode([String: Data].self, from: data)
        } catch {
            print("No existing cache found or failed to load: \(error)")
        }
    }
    
    private func getCacheFileURL() -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(cacheFileName)
    }
}
