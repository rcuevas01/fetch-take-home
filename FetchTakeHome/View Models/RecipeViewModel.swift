//
//  RecipeViewModel.swift
//  FetchTakeHome
//
//  Created by Ruben Cuevas on 2/27/25.
//

import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    @Published var selectedCuisine: String? = nil
    @Published var availableCuisines: [String] = []
    
    private let networkManager: RecipeNetworkProtocol
    private let imageCache: ImageCacheProtocol
    
    init(networkManager: RecipeNetworkProtocol = RecipeNetworkManager(),
         imageCache: ImageCacheProtocol = ImageCache()) {
        self.networkManager = networkManager
        self.imageCache = imageCache
    }
    
    @MainActor
    func loadRecipes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedRecipes = try await networkManager.fetchRecipes(endpoint: nil)
            self.recipes = fetchedRecipes
            self.getAvailableCuisines()
        } catch NetworkError.emptyData {
            errorMessage = "No recipes available!"
            self.recipes = []
        } catch NetworkError.malformedData {
            errorMessage = "Failed to load recipes!"
            self.recipes = []
        } catch {
            errorMessage = "Failed to load recipes!"
            self.recipes = []
        }
        
        isLoading = false
    }
    
    func getAvailableCuisines() {
        let cuisines = Set(recipes.map { $0.cuisine })
        availableCuisines = Array(cuisines).sorted()
    }
    
    var filteredRecipes: [Recipe] {
        var result = recipes
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        
        if let cuisine = selectedCuisine {
            result = result.filter { $0.cuisine == cuisine }
        }
        return result
    }
    
    // Helper to load image from image cache
    func loadImage(from urlString: String?, recipeId: String?) async -> Image? {
        guard let urlString = urlString,
              let url = URL(string: urlString),
              let recipeId = recipeId else {
            return nil
        }
        
        return await withCheckedContinuation { continuation in
            imageCache.getImage(url: url, recipeId: recipeId) { image in
                continuation.resume(returning: image)
            }
        }
    }
}
