import Foundation

protocol RecipeNetworkProtocol {
    func fetchRecipes(endpoint: String?) async throws -> [Recipe]
}

enum NetworkError: Error {
    case malformedData
    case emptyData
    case invalidResponse
}

class RecipeNetworkManager: RecipeNetworkProtocol {
    private let baseURL = "https://d3jbb8n5wk0qxi.cloudfront.net"
    
    func fetchRecipes(endpoint: String? = "/recipes.json") async throws -> [Recipe] {
        let urlString = baseURL + (endpoint ?? "/recipes.json")
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(RecipeList.self, from: data)
                
                if decodedResponse.recipes.isEmpty {
                    throw NetworkError.emptyData
                }
                
                return decodedResponse.recipes
            } catch let error as NetworkError {
                throw error
            } catch {
                throw NetworkError.malformedData
            }
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.invalidResponse
        }
    }
}
