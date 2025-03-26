//
//  ViewModel.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//



import SwiftUI

class ViewModel<T: Decodable>: VMProtocol {
    @Published var data: T? = nil
    let repo: RepoProtocol
    var error: APIError?
    
    init(repository: RepoProtocol = Repo.shared) {
        self.repo = repository
    }
    
    @MainActor
    func fetch(_ url: String) async {
//        print("Fetching Data from Repository: \(url)")
        do {
            self.data = try await repo.fetch(url: url)
            self.error = nil
        } catch {
            self.data = nil
            self.error = APIError.RequestError(msg: error.localizedDescription)
        }
//        print(err?.msg ?? "Succeeded")
//        print(data ?? "none")
    }
}
