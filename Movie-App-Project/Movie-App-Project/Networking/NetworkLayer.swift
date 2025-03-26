//
//  NetworkLayer.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import Foundation

class NetworkLayer: NetworkService {
    func get(url: String) async throws -> Data? {
        // Validate URL
        guard let urlObj = URL(string: url) else {
            throw APIError.InvalidURL(msg: "Invalid URL: \(url)")
        }
        
        // Fetch data using URLSession
        let (data, response) = try await URLSession.shared.data(from: urlObj)
        
        // Check for a valid HTTP response (status code 200-299)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.Unknown(msg: "Server responded with an error.")
        }
        
        // Ensure data is not empty
        guard !data.isEmpty else {
            throw APIError.NoData
        }
        
        return data
    }
}
