//
//  ErrorView.swift
//  FetchTakeHome
//
//  Created by Ruben Cuevas on 2/27/25.
//

import SwiftUI

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text(errorText)
                .font(.title)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("🐶👨‍🍳")
                .font(.system(size: 80))
                .padding()
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}
