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
    static let shared = ImageRepo()
    
    // Use NSCache for thread-safe caching.
    private var imageCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let imageDirectory: URL
    
    private init() {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        imageDirectory = paths[0].appendingPathComponent("ImageRepo", isDirectory: true)
        if !fileManager.fileExists(atPath: imageDirectory.path) {
            try? fileManager.createDirectory(at: imageDirectory, withIntermediateDirectories: true)
        }
    }
    
    func fetchImage(url: String) async throws -> UIImage? {
        guard !url.isEmpty else {
            print("Invalid empty URL")
            return nil
        }
        
        let key = url as NSString
        
        // Check NSCache for a cached image.
        if let cachedImage = imageCache.object(forKey: key) {
            return cachedImage
        }
        
        // Check local storage.
        let filePath = self.filePath(for: url)
        if let image = loadImage(from: filePath) {
            imageCache.setObject(image, forKey: key)
            return image
        }
        
        // Download image.
        guard let imageURL = URL(string: url) else {
            throw APIError.invalidURL(message: "Invalid URL: \(url)")
        }
        
        let (data, response) = try await URLSession.shared.data(from: imageURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.requestError(message: "Failed to load image from \(url)")
        }
        
        guard let image = UIImage(data: data) else {
            throw APIError.requestError(message: "Invalid image data at \(url)")
        }
        
        // Cache in NSCache and save locally.
        imageCache.setObject(image, forKey: key)
        try? data.write(to: filePath)
        
        return image
    }
    
    func saveProfileImage(for email: String, image: UIImage) throws {
        let keyString = sanitize(email)
        let filePath = self.filePath(for: keyString)
        guard let data = image.pngData() else {
            throw APIError.requestError(message: "Unable to convert image to data")
        }
        try data.write(to: filePath)
        imageCache.setObject(image, forKey: keyString as NSString)
    }
    
    func fetchProfileImage(for email: String) -> UIImage? {
        let keyString = sanitize(email)
        let key = keyString as NSString
        if let cachedImage = imageCache.object(forKey: key) {
            return cachedImage
        }
        let filePath = self.filePath(for: keyString)
        if let image = loadImage(from: filePath) {
            imageCache.setObject(image, forKey: key)
            return image
        }
        return nil
    }
    
    // Helper: Sanitize keys for file storage.
    private func sanitize(_ key: String) -> String {
        key.replacingOccurrences(of: "/", with: "_")
           .replacingOccurrences(of: ":", with: "_")
    }
    
    // Helper: Get file URL for a given key.
    private func filePath(for key: String) -> URL {
        let fileName = sanitize(key)
        return imageDirectory.appendingPathComponent(fileName)
    }
    
    // Helper: Load image from a file URL.
    private func loadImage(from url: URL) -> UIImage? {
        if fileManager.fileExists(atPath: url.path),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            return image
        }
        return nil
    }
}
