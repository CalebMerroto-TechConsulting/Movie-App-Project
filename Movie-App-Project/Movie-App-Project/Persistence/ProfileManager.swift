//
//  ProfileManager.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import SwiftUI
import FirebaseAuth

class ProfileManager: ObservableObject {
    static let shared = ProfileManager()
    
    @Published private(set) var username: String = ""
    @Published private(set) var email: String = ""
    @Published private(set) var profileImage: UIImage = UIImage(systemName: "person.circle")!
    @Published private(set) var favorites: [String] = []
    
    // Injected dependencies
    var auth: AuthService = AuthManager.shared
    private let db: UserDatabaseProtocol = DBManager()
    
    private let defaultImg = UIImage(systemName: "person.circle")!
    
    // Computed property to get the current user.
    private var user: User? { auth.currentUser }
    
    private init() { }
    
    func loadProfile(completion: @escaping () -> Void = {}) {
        guard let uid = user?.uid, let currentEmail = user?.email else {
            print("No user logged in – cannot load profile.")
            DispatchQueue.main.async {
                self.unloadProfile()
                completion()
            }
            return
        }
        
        db.getUserDocument(uid: uid) { data, error in
            var newFavorites: [String] = []
            var newUsername: String = ""
            if let error = error {
                print("Error loading profile: \(error.localizedDescription)")
            } else if let data = data {
                newFavorites = data["favorites"] as? [String] ?? []
                newUsername = data["username"] as? String ?? ""
            }
            let newImage = ImageRepo.shared.fetchProfileImage(for: currentEmail) ?? self.defaultImg
            
            DispatchQueue.main.async {
                self.email = currentEmail
                self.favorites = newFavorites
                self.username = newUsername
                self.profileImage = newImage
                completion()
            }
        }
    }
    
    func unloadProfile() {
        self.email = ""
        self.username = ""
        self.favorites = []
        self.profileImage = self.defaultImg
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
    
    func setProfileImage(_ image: UIImage) {
        guard let email = user?.email else {
            print("No user logged in – cannot update profile image.")
            return
        }
        do {
            try ImageRepo.shared.saveProfileImage(for: email, image: image)
            DispatchQueue.main.async {
                self.profileImage = image
            }
        } catch {
            print("Could not save profile image: \(error.localizedDescription)")
        }
    }
    
    func setUsername(_ username: String) {
        guard user?.email != nil else {
            print("No user logged in – cannot update username.")
            return
        }
        self.username = username
        updateFirestore()
    }
    
    private func updateFirestore() {
        guard let uid = user?.uid else {
            print("No user logged in – cannot update profile.")
            return
        }
        let data: [String: Any] = [
            "favorites": favorites,
            "username": username
        ]
        db.updateUserDocument(uid: uid, data: data) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully.")
            }
        }
    }
}
