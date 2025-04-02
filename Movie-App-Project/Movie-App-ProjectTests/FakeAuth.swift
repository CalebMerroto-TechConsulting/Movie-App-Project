//
//  FakeAuth.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 4/2/25.
//

import FirebaseAuth


class FakeAuth {
    static var currentUser: User? = nil
}

// Fake DocumentSnapshot to simulate Firestore document data.
class FakeDocumentSnapshot {
    private let dataDict: [String: Any]?
    init(data: [String: Any]?) {
        self.dataDict = data
    }
    func data() -> [String: Any]? {
        return dataDict
    }
}

// Fake DocumentReference to simulate Firestore document behavior.
class FakeDocumentReference {
    var data: [String: Any]?
    func getDocument(completion: @escaping (FakeDocumentSnapshot?, Error?) -> Void) {
        completion(FakeDocumentSnapshot(data: data), nil)
    }
    func setData(_ data: [String: Any], merge: Bool, completion: ((Error?) -> Void)? = nil) {
        self.data = data
        completion?(nil)
    }
}

// Fake CollectionReference to simulate a Firestore collection.
class FakeCollectionReference {
    var documents: [String: FakeDocumentReference] = [:]
    func document(_ documentID: String) -> FakeDocumentReference {
        if let doc = documents[documentID] {
            return doc
        } else {
            let newDoc = FakeDocumentReference()
            documents[documentID] = newDoc
            return newDoc
        }
    }
}

// Fake Firestore that returns our fake collection.
class FakeFirestore {
    var collections: [String: FakeCollectionReference] = [:]
    func collection(_ collectionPath: String) -> FakeCollectionReference {
        if let col = collections[collectionPath] {
            return col
        } else {
            let newCol = FakeCollectionReference()
            collections[collectionPath] = newCol
            return newCol
        }
    }
}
