//
//  AuthManager.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/27/25.
//

import FirebaseAuth
import FirebaseAnalytics


class AuthManager: AuthService {
    private init() {}
    static let shared = AuthManager()
    var currentUser: User? { Auth.auth().currentUser }
    
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let user = authResult?.user else {
                completion(.failure(self.unknownError(with: "sign in")))
                return
            }
            
            // Log the sign-in event on success.
            Analytics.logEvent(AnalyticsEventLogin, parameters: [
                AnalyticsParameterMethod: "password"
            ])
            // Load user-specific favorites.
            ProfileManager.shared.loadProfile()
            completion(.success(user))
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard authResult?.user != nil else {
                completion(.failure(self.unknownError(with: "sign up")))
                return
            }
            
            // Log the sign-up event on success.
            Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                AnalyticsParameterMethod: "password"
            ])
            // Automatically sign in after sign up.
            self.signIn(email: email, password: password, completion: completion)
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Error?) -> Void = { _ in }) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    private func unknownError(with action: String) -> NSError {
        NSError(domain: "AuthManager", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown \(action) error."])
    }
}
