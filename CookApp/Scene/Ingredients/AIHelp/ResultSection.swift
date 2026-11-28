//
//  ResultSection.swift
//  CookApp
//
//  Created by Javid Sultanov on 28.11.26.
//

import SwiftUI
import Kingfisher

struct ResultSection: View {
    @Bindable var viewModel: AIHelpViewModel
    var recipeTapped: ((Int) -> Void)?
    
    var body: some View {
        Group {
            switch viewModel.resultState {
            case .idle:
                EmptyView()
            case .loading:
                ProgressView()
                    .tint(.atlasOrange)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                
            case .loaded:
                VStack(alignment: .leading, spacing: 8) {
                    if !viewModel.sampleNames.isEmpty {
                        Text("Found: \(viewModel.sampleNames.joined(separator: ", "))")
                            .font(.subheadline)
                            .foregroundStyle(.atlasGray)
                    }
                    
                    Text("Suggested Recipes:")
                        .font(.title2.bold())
                        .foregroundStyle(.atlasGray)
                    
                    if viewModel.picks.isEmpty {
                        Text("No recipes found. Try other ingredients or one more time.")
                            .foregroundStyle(.atlasGray)
                    }
                    
                    ForEach(viewModel.picks, id: \.recipeID) { pick in
                        if let recipe = viewModel.recipe(id: pick.recipeID) {
                            Button {
                                recipeTapped?(pick.recipeID)
                            } label: {
                                HStack(spacing: 8) {
                                    if let image = recipe.imageURL {
                                        KFImage(URL(string: image))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(.rect(cornerRadius: 12))
                                    }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            if let title = recipe.title {
                                                Text(title)
                                                    .font(.headline)
                                                    .foregroundStyle(.atlasDark)
                                            }
                                            
                                            if let flag = recipe.flagEmoji,
                                               let cookTime = recipe.cookTimeMinutes {
                                                Text("\(flag) \(cookTime) minutes")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.atlasGray)
                                            }
                                            
                                            Text(pick.reason)
                                                .font(.caption)
                                                .foregroundStyle(.atlasOrange)
                                                .multilineTextAlignment(.leading)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.atlasGray)
                                    }
                                .padding()
                                .background(.white, in: .rect(cornerRadius: 20))
                            }
                        }
                    }
                }
                
            case .error(let errorMessage):
                Color.clear
                    .alert("Error", isPresented: $viewModel.showError) {
                        Button("OK") {}
                    } message: {
                        Text(errorMessage)
                    }
            }
        }
    }
}
