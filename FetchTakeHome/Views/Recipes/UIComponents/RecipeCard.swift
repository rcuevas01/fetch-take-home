import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipeViewModel
    @State private var image: Image?
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.name)
                        .font(.title)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading).foregroundColor(.black)
                    
                    Text(recipe.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Right side: Image
                ZStack {
                    if isLoading {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                            .overlay(ProgressView())
                    }
                    
                    if let image = image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                            .clipped()
                    }
                }
                .frame(width: 100, height: 100)
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            
            Divider()
                .padding(.vertical, 8)
            
            // Bottom buttons for YouTube and Website
            HStack(spacing: 24) {
                
                if let videoURL = recipe.youtube_url, !videoURL.isEmpty {
                    Button(action: {
                        if let url = URL(string: videoURL) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.red)
                            Text("Video")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                }
                
                if let sourceURL = recipe.source_url, !sourceURL.isEmpty {
                    
                    Button(action: {
                        if let url = URL(string: sourceURL) {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "link.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                            Text("Website")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                }
                
                Spacer()
                
                // Share Button
                ShareLink(
                    item: "Hi! I think we should make \(recipe.name). \(recipe.source_url != nil ? "Here's the recipe: \(recipe.source_url!)" : (recipe.youtube_url != nil ? "Here's the video: \(recipe.youtube_url!)" : ""))",
                    subject: Text("Check out this recipe")
                ) {
                    VStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        Text("Share")
                            .font(.caption).foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        isLoading = true
        
        if let urlString = recipe.photo_url_small {
            if let loadedImage = await viewModel.loadImage(from: urlString, recipeId: recipe.id) {
                image = loadedImage
            }
        }
        
        isLoading = false
    }
}

