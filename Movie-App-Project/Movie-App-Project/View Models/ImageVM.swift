//
//  ImageVM.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//

import SwiftUI

class ImageVM: VMProtocol {
    @Published var data: UIImage?
    @Published var error: APIError?
    private let repository: ImageRepoProtocol

    init(repository: ImageRepoProtocol = ImageRepo.shared) {
        self.repository = repository
    }
    
    @MainActor
    func fetch(_ url: String) async {
        do {
            data = try await repository.fetchImage(url: url)
            error = nil
        } catch {
            data = nil
            // Use the error directly if it's already an APIError, otherwise wrap it.
//            print("Fetching Image from Repository: \(url)")
            if let apiError = error as? APIError {
                self.error = apiError
            } else {
                self.error = APIError.requestError(message: error.localizedDescription)
            }
//            print(self.error?.message ?? "Succeeded")
        }
    }
}
