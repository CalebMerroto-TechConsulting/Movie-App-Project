//
//  FavoritesManager.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published private(set) var favorites: [String] = []
    
    private let db = Firestore.firestore()
    
    // Remove the call from init—load favorites after sign in.
    private init() { }
    
    /// Call this function after a user signs in to load their favorites.
    func loadFavorites() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in – cannot load favorites.")
            self.favorites = []
            return
        }
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Error loading favorites: \(error.localizedDescription)")
                return
            }
            if let data = snapshot?.data(), let favs = data["favorites"] as? [String] {
                DispatchQueue.main.async {
                    self.favorites = favs
                }
            } else {
                DispatchQueue.main.async {
                    self.favorites = []
                }
            }
        }
    }
    
    func getFavorites() -> [String] {
        favorites
    }
    
    func isFavorite(_ movieTitle: String) -> Bool {
        favorites.contains(movieTitle)
    }
    
    func addFavorite(_ movieTitle: String) {
        guard !favorites.contains(movieTitle) else { return }
        favorites.append(movieTitle)
        updateFirestore()
    }
    
    func removeFavorite(_ movieTitle: String) {
        if let index = favorites.firstIndex(of: movieTitle) {
            favorites.remove(at: index)
            updateFirestore()
        }
    }
    
    private func updateFirestore() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in – cannot update favorites.")
            return
        }
        let docRef = db.collection("users").document(uid)
        docRef.setData(["favorites": favorites], merge: true) { error in
            if let error = error {
                print("Error updating favorites: \(error.localizedDescription)")
            } else {
                print("Favorites updated successfully.")
            }
        }
    }
}
