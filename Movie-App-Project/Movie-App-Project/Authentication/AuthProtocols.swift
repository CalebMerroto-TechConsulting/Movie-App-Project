//
//  AuthProtocols.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 4/2/25.
//

import FirebaseAuth
import FirebaseFirestore

protocol AuthService {
    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func signOut() throws
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func resetPassword(email: String, completion: @escaping (Error?) -> Void)
    var currentUser: User? { get }
}

protocol UserDatabaseProtocol {
    func getUserDocument(uid: String, completion: @escaping ([String: Any]?, Error?) -> Void)
    func updateUserDocument(uid: String, data: [String: Any], completion: @escaping (Error?) -> Void)
    
}
