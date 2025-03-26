//
//  FavoritesManager.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//



import SwiftUI

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    private let favoritesKey = "favorites"
    private var newFaves: [String] = []
    private init() {}
    
    // Retrieve the list of favorited movie titles.
    func getFavorites() -> [String] {
        var allFaves:[String] = []
        for movie in (UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []) + newFaves {
            if !allFaves.contains(movie) {
                allFaves.append(movie)
            }
        }
        return allFaves
    }
    
    // Check if a given movie title is favorited.
    func isFavorite(_ movieTitle: String) -> Bool {
        getFavorites().contains(movieTitle) || newFaves.contains(movieTitle)
    }
    
    // Add a movie title to the favorites list.
    func addFavorite(_ movieTitle: String) {
        var favorites = getFavorites()
        if !favorites.contains(movieTitle) {
            favorites.append(movieTitle)
            UserDefaults.standard.set(favorites, forKey: favoritesKey)
        }
        newFaves.append(movieTitle)
    }
    
    // Remove a movie title from the favorites list.
    func removeFavorite(_ movieTitle: String) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(of: movieTitle) {
            favorites.remove(at: index)
            UserDefaults.standard.set(favorites, forKey: favoritesKey)
        }
        if let index = newFaves.firstIndex(of: movieTitle) {
            newFaves.remove(at: index)
        }
    }
}
