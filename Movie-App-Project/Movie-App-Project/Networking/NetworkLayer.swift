//
//  NetworkLayer.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import Foundation

class NetworkLayer: NetworkService {
    func get(url: String) async throws -> Data? {
        // Validate URL string.
        guard let urlObj = URL(string: url) else {
            throw APIError.invalidURL(message: "Invalid URL: \(url)")
        }
        
        // Fetch data using URLSession.
        let (data, response) = try await URLSession.shared.data(from: urlObj)
        
        // Validate the HTTP response.
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown(message: "Invalid response received from the server.")
        }
        
        // Check for a valid status code (200-299).
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.unknown(message: "Server responded with status code: \(httpResponse.statusCode)")
        }
        
        // Ensure the response data is not empty.
        guard !data.isEmpty else {
            throw APIError.noData
        }
        
        return data
    }
}

