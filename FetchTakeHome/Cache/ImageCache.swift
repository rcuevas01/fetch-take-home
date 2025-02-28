import Foundation
import SwiftUI

protocol ImageCacheProtocol {
    func getImage(url: URL, recipeId: String, completion: @escaping (Image?) -> Void)
}

class ImageCache: ImageCacheProtocol {
    private let fileManager = FileManager.default
    
    private var cacheDirectory: URL? {
        return try? fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("RecipeImageCache", isDirectory: true)
    }
    
    init() {
        if let cacheDirectory = cacheDirectory, !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    func getImage(url: URL, recipeId: String, completion: @escaping (Image?) -> Void) {
        let key = recipeId
        
        // Check cache first
        if let image = loadImage(forKey: key) {
            completion(image)
            return
        }
        
        // Download image if it's not cached
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let uiImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let image = Image(uiImage: uiImage)
            
            self.saveImage(data: data, forKey: key)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    // Create a filename based on the recipe ID
    private func fileURL(forKey key: String) -> URL? {
        guard let cacheDirectory = cacheDirectory else { return nil }
        
        let filename = "recipe_\(key.replacingOccurrences(of: "-", with: "_"))"
        
        return cacheDirectory.appendingPathComponent(filename)
    }
    
    // Save the image to cache
    private func saveImage(data: Data, forKey key: String) {
        guard let fileURL = fileURL(forKey: key) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
    // Load the image from cache
    private func loadImage(forKey key: String) -> Image? {
        guard let fileURL = fileURL(forKey: key),
              fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let uiImage = UIImage(data: data) else {
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
}
