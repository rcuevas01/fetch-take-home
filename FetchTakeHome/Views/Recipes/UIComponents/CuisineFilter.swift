//
//  CuisineFilter.swift
//  FetchTakeHome
//
//  Created by Ruben Cuevas on 2/27/25.
//

import SwiftUI

struct CuisineFilter: View {
    @ObservedObject var viewModel: RecipeViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Select Cuisine")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("Done") {
                    isPresented = false
                }
                .foregroundColor(.blue)
            }
            .padding()
            .background(Color.white)
            
            Divider()
            
            
            ScrollView {
                VStack(spacing: 0) {
                    // All Cuisines option
                    Button(action: {
                        viewModel.selectedCuisine = nil
                        isPresented = false
                    }) {
                        HStack {
                            ZStack {
                                Circle()
                                    .stroke(Color.blue, lineWidth: 2)
                                    .frame(width: 22, height: 22)
                                
                                if viewModel.selectedCuisine == nil {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 12, height: 12)
                                }
                            }
                            
                            Text("All Cuisines")
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .padding(.leading, 12)
                            
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .background(Color.white)
                    }
                    
                    Divider()
                    
                    // Individual cuisines options
                    ForEach(viewModel.availableCuisines, id: \.self) { cuisine in
                        Button(action: {
                            viewModel.selectedCuisine = cuisine
                            isPresented = false
                        }) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .stroke(Color.blue, lineWidth: 2)
                                        .frame(width: 22, height: 22)
                                    
                                    if viewModel.selectedCuisine == cuisine {
                                        Circle()
                                            .fill(Color.blue)
                                            .frame(width: 12, height: 12)
                                    }
                                }
                                
                                Text(cuisine)
                                    .font(.system(size: 18))
                                    .foregroundColor(.black)
                                    .padding(.leading, 12)
                                
                                Spacer()
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal)
                            .background(Color.white)
                        }
                        
                        Divider()
                    }
                }
            }
        }
        .background(Color.white)
    }
}
