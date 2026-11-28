//
//  RecommendedSection.swift
//  CookApp
//
//  Created by Javid Sultanov on 28.11.26.
//

import SwiftUI
import Kingfisher

struct RecommendedSection: View {
    let viewModel: DiscoverViewModel
    var recipeTapped: ((Int) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Recommended: \(viewModel.recommendedCategory)")
                    .font(.title2.bold())
                    .foregroundStyle(.atlasGray)
                Spacer()
                Button {
                    withAnimation {
                        viewModel.newRecommendedRecipes()
                    }
                } label: {
                    Label("Refresh", systemImage: "arrow.clockwise")
                        .font(.subheadline.bold())
                        .foregroundStyle(.blue)
                }
            }
            
            LazyVGrid(columns: [GridItem(.flexible())]) {
                ForEach(viewModel.recommendedRecipes, id: \.id) { recipe in
                    Button {
                        if let id = recipe.id {
                            recipeTapped?(id)
                        }
                    } label: {
                        HStack(spacing: 8) {
                            if let image = recipe.imageURL {
                                KFImage(URL(string: image))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                            
                            VStack(alignment: .leading) {
                                if let title = recipe.title {
                                    Text(title)
                                        .font(.headline)
                                        .foregroundStyle(.atlasDark)
                                        .lineLimit(0)
                                }
                                
                                if let flag = recipe.flagEmoji,
                                   let cuisine = recipe.cuisineName,
                                   let cookTime = recipe.cookTimeMinutes {
                                    Text("\(flag) \(cuisine) · \(cookTime) minutes")
                                        .font(.subheadline)
                                        .foregroundStyle(.atlasGray)
                                }
                                
                                Text(recipe.difficultyText)
                                    .font(.caption.bold())
                                    .foregroundStyle(Color(recipe.difficultyColor))
                                
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
            .scrollIndicators(.hidden)
        }
    }
}
