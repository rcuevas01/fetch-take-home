import Foundation

struct RecipeList: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable, Identifiable {
    let name: String
    let uuid: String
    let cuisine: String
    let source_url: String?
    let youtube_url: String?
    let photo_url_large: String?
    let photo_url_small: String?
    
    var id: String { uuid }
}
