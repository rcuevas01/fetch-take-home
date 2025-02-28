import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeViewModel(
        networkManager: RecipeNetworkManager(),
        imageCache: ImageCache()
    )
    @State private var showCuisineFilter = false
    
    private let columns = [
        GridItem(.flexible(minimum: 0, maximum: .infinity)),
    ]
    
    var body: some View {
        ZStack {
            Color(UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0))
                    .edgesIgnoringSafeArea(.all)
        
            VStack(spacing: 0) {
                
                
                Text("Fetch Recipes")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search recipe names...", text: $viewModel.searchText)
                            .disableAutocorrection(true)
                    }
                    .padding(10)
                    .background(Color(.systemGray2))
                    .cornerRadius(20)
                    
                    // Filter button
                    Button(action: {
                        showCuisineFilter = true
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                    .padding(.leading, 8)
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
                
                // Recipe list
                ScrollView {
                    if viewModel.isLoading && viewModel.recipes.isEmpty {
                        ProgressView("Loading recipes...")
                            .padding(.top, 40)
                    }
                    else if viewModel.filteredRecipes.isEmpty && !viewModel.searchText.isEmpty {
                        ErrorView(errorText: "No recipes found matching '\(viewModel.searchText)'")
                    }
                    
                    else if let error = viewModel.errorMessage {
                        ErrorView(errorText: error).padding(.top, 80)
                    }
                     else {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.filteredRecipes) { recipe in
                                RecipeCard(recipe: recipe, viewModel: viewModel)
                                    .frame(maxWidth: .infinity)
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .refreshable {
                    await viewModel.loadRecipes()
                }
                
                // Refreshing
                if viewModel.isLoading && !viewModel.recipes.isEmpty {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                                .background(Color.primary.colorInvert().opacity(0.7))
                                .cornerRadius(10)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
        }
        .task {
            await viewModel.loadRecipes()
        }
        .sheet(isPresented: $showCuisineFilter) {
            CuisineFilter(viewModel: viewModel, isPresented: $showCuisineFilter)
        }
    }
}


// Preview Provider
struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
