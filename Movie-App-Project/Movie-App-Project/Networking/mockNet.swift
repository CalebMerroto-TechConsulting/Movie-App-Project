//
//  mockNet.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 4/1/25.
//

import Foundation

class mockNet: NetworkService {
    func get(url: String) async throws -> Data? {
        // Check for the TasteDive API URL.
        if url == tasteDiveURL("Avengers") {
            // Locate the MockMovieSearch.json file in the "Networking" subdirectory.
            guard let fileURL = Bundle.main.url(forResource: "MockMovieSearch", withExtension: "json", subdirectory: "Networking") else {
                throw APIError.requestError(message: "Mock Movie Names file not found")
            }
            return try Data(contentsOf: fileURL)
        }
        
        // Check if the URL is for OMDB.
        if url.starts(with: "https://www.omdbapi.com/") {
            // Parse the URL to extract query parameters.
            guard let components = URLComponents(string: url),
                  let queryItems = components.queryItems else {
                throw APIError.requestError(message: "Invalid OMDB URL")
            }
            
            // Extract and decode the movie title from the "t" query parameter.
            guard let movieTitleEncoded = queryItems.first(where: { $0.name == "t" })?.value,
                  let movieTitle = movieTitleEncoded.removingPercentEncoding else {
                throw APIError.requestError(message: "Movie title missing")
            }
            
            // Load the MockMovieData.json file from the "Networking" subdirectory.
            guard let fileURL = Bundle.main.url(forResource: "MockMovieData", withExtension: "json", subdirectory: "Networking") else {
                throw APIError.requestError(message: "Mock Movie Data file not found")
            }
            let fileData = try Data(contentsOf: fileURL)
            
            // Parse the file data into a dictionary.
            let jsonObject = try JSONSerialization.jsonObject(with: fileData, options: [])
            if let moviesDict = jsonObject as? [String: Any],
               let movieData = moviesDict[movieTitle] {
                // Return the JSON data for the individual movie.
                return try JSONSerialization.data(withJSONObject: movieData, options: [])
            } else {
                throw APIError.requestError(message: "Movie '\(movieTitle)' not found in mock data")
            }
        }
        
        return nil
    }
}
