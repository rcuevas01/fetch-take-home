import Testing
import SwiftUI
import XCTest
import Foundation
@testable import FetchTakeHome

struct FetchTakeHomeTests {
    
    // Test normal fetch with default endpoint
    @Test func testNormalFetch() async throws {
        
        let networkManager = RecipeNetworkManager()
        
        do {
            let recipes = try await networkManager.fetchRecipes(endpoint: nil)
            #expect(!recipes.isEmpty, "Recipes should not be empty")
            
            // Check for required properties
            if let firstRecipe = recipes.first {
                #expect(!firstRecipe.id.isEmpty, "Recipe should have valid ID")
                #expect(!firstRecipe.name.isEmpty, "Recipe should have a name")
                #expect(!firstRecipe.cuisine.isEmpty, "Recipe should have a cuisine")
            }
        } catch {
            #expect(false, "Normal fetch failed: \(error)")
        }
    }
    
    // Test with endpoint that returns malformed data
    @Test func testMalformedData() async throws {
        
        let networkManager = RecipeNetworkManager()
        
        do {
            _ = try await networkManager.fetchRecipes(endpoint: "/recipes-malformed.json")
            #expect(false, "Expected malformedData error but got success")
        } catch let error as NetworkError {
            switch error {
            case .malformedData:
                #expect(true, "Correctly found malformedData error")
            default:
                #expect(false, "Expected malformedData error but got \(error)")
            }
        } catch {
            #expect(false, "Expected malformedData but got different error: \(error)")
        }
    }
    
    // Test with endpoint that returns empty recipe list
    @Test func testEmptyData() async throws {
        let networkManager = RecipeNetworkManager()
        
        do {
            _ = try await networkManager.fetchRecipes(endpoint: "/recipes-empty.json")
            #expect(false, "Expected emptyData error but got success")
        } catch let error as NetworkError {
            switch error {

            case .emptyData:
                #expect(true, "Correctly caught emptyData error")
            default:
                #expect(false, "Expected emptyData error but got \(error)")
            }
        }
    }
    
    // Ensure that filtering works
    @Test func filterRecipes() async throws {
        let networkManager = RecipeNetworkManager()
        let viewModel = RecipeViewModel(networkManager: networkManager)
        
        await viewModel.loadRecipes()
        viewModel.selectedCuisine = "Portuguese"
        
        #expect(viewModel.filteredRecipes.count == 1)
        
    }
    
    // Ensure that searching works
    @Test func searchRecipes() async throws {
        let networkManager = RecipeNetworkManager()
        let viewModel = RecipeViewModel(networkManager: networkManager)
        
        await viewModel.loadRecipes()
        viewModel.searchText = "Apple"
        
        #expect(viewModel.filteredRecipes.count == 3)
    }
    
    
    // Test image caching to ensure that it saves and loads the image
    @Test func imageCache() async throws {
        
        let imageCache = ImageCache()
        let imageURL = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!
        let recipeId = "recipe-123"
        
        // Download image
        var downloadedImage: Image? = nil
        
        let task = Task {
            await withCheckedContinuation { continuation in
                imageCache.getImage(url: imageURL, recipeId: recipeId) { image in
                    downloadedImage = image
                    continuation.resume()
                }
            }
        }
        
        await task.value
        
        // Verify we get the image
        #expect(downloadedImage != nil, "Should have downloaded an image")
        
        // Check if file exists in cache directory
        let fileManager = FileManager.default
        let cacheDir = try? fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("RecipeImageCache", isDirectory: true)
        
        // Create filename
        let key = recipeId
        let filename = "recipe_\(key.replacingOccurrences(of: "-", with: "_"))"
        
        let expectedFilePath = cacheDir?.appendingPathComponent(filename).path
        
        // Verify file exists in cache
        if let path = expectedFilePath {
            #expect(fileManager.fileExists(atPath: path), "Image should exist in cache directory")
        }
        
        var cachedImage: Image? = nil
        let cacheTask = Task {
            await withCheckedContinuation { continuation in
                imageCache.getImage(url: imageURL, recipeId: recipeId) { image in
                    cachedImage = image
                    continuation.resume()
                }
            }
        }
        
        await cacheTask.value
        
        // Verify we got image from cache
        #expect(cachedImage != nil, "Should retrieve image from cache")
    }
}
