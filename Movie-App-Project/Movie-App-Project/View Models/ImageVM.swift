//
//  ImageVM.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//



import SwiftUI

class ImageVM: VMProtocol {
    @Published var data: UIImage? = nil
    @Published var error: APIError? = nil
    let repo: ImageRepoProtocol
    
    init(repository: ImageRepoProtocol = ImageRepo()) {
        self.repo = repository
    }
    
    @MainActor
    func fetch(_ url: String) async {
//        print("Fetching Image from Repository: \(url)")
        do {
            self.data = try await repo.fetchImage(url: url)
            self.error = nil
        } catch {
            self.data = nil
            self.error = APIError.RequestError(msg: error.localizedDescription)
        }
//        print(err?.msg ?? "Succeeded")
    }
}
