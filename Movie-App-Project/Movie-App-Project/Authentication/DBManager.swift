//
//  DBManager.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 4/2/25.
//

import FirebaseFirestore

class DBManager: UserDatabaseProtocol {
    private let db = Firestore.firestore()
    
    func getUserDocument(uid: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        let docRef = db.collection("users").document(uid)
        docRef.getDocument { snapshot, error in
            completion(snapshot?.data(), error)
        }
    }
    
    func updateUserDocument(uid: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        let docRef = db.collection("users").document(uid)
        docRef.setData(data, merge: true, completion: completion)
    }
}
