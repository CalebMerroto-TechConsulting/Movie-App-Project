//
//  AuthManager.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/27/25.
//

import FirebaseAuth
import FirebaseAnalytics

protocol AuthService {
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func signOut() throws
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func resetPassword(email: String, completion: @escaping (Error?) -> Void)
}

class AuthManager: AuthService {
    private init() {}
    static let shared = AuthManager()

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                // Log the sign-in event on success.
                Analytics.logEvent(AnalyticsEventLogin, parameters: [
                    AnalyticsParameterMethod: "password"
                ])
                // Load user-specific favorites.
                FavoritesManager.shared.loadFavorites()
                completion(.success(user))
            } else {
                completion(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown sign in error."])))
            }
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if (authResult?.user) != nil {
                // Log the sign-up event on success.
                Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                    AnalyticsParameterMethod: "password"
                ])
                // Automatically sign in after sign up.
                self.signIn(email: email, password: password, completion: completion)
            } else {
                completion(.failure(NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown sign up error."])))
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Error?) -> Void = { _ in }) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}
