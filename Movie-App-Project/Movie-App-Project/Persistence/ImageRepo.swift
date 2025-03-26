//
//  ImageRepoProtocol.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/26/25.
//


import SwiftUI

protocol ImageRepoProtocol {
    func fetchImage(url: String) async throws -> UIImage?
}

class ImageRepo: ImageRepoProtocol {
    
    private var imageCache: [String: UIImage] = [:] // In-memory cache
    private let fileManager = FileManager.default
    private let imageDirectory: URL
    
    init() {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        self.imageDirectory = paths[0].appendingPathComponent("ImageRepo", isDirectory: true)
        
        if !fileManager.fileExists(atPath: imageDirectory.path) {
            try? fileManager.createDirectory(at: imageDirectory, withIntermediateDirectories: true)
        }
    }
    
    func fetchImage(url: String) async throws -> UIImage? {
        let fileName = url.replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: ":", with: "_")
        let filePath = imageDirectory.appendingPathComponent(fileName)

        // **Check In-Memory Cache**
        if let cachedImage = imageCache[url] {
            return cachedImage
        }
        
        // **Check Local Storage**
        if fileManager.fileExists(atPath: filePath.path),
           let data = try? Data(contentsOf: filePath),
           let image = UIImage(data: data) {
            imageCache[url] = image
            return image
        }
        
        // **Download Image**
        guard let imageURL = URL(string: url) else {
            return nil
        }
        
        let (data, response) = try await URLSession.shared.data(from: imageURL)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.RequestError(msg: "Failed to load image from \(url)")
        }
        
        guard let image = UIImage(data: data) else {
            throw APIError.RequestError(msg: "Invalid image data at \(url)")
        }
        
        // **Cache & Save Image**
        imageCache[url] = image
        try? data.write(to: filePath)  // Save image locally
        
        return image
    }
}
