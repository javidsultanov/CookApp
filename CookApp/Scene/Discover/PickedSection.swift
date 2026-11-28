//
//  PickedSection.swift
//  CookApp
//
//  Created by Javid Sultanov on 28.11.26.
//

import SwiftUI
import Kingfisher

struct PickedSection: View {
    let recipes: [RecipeCard]
    var recipeTapped: ((Int) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("What would you like to cook today?")
                .font(.largeTitle.bold())
                .foregroundStyle(.atlasDark)
                .padding(.vertical)
            
            Text("Picked for You:")
                .font(.title2.bold())
                .foregroundStyle(.atlasGray)
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(200))], spacing: 8) {
                    ForEach(recipes, id: \.id) { recipe in
                        Button {
                            if let id = recipe.id {
                                recipeTapped?(id)
                            }
                        } label: {
                            VStack(spacing: 8) {
                                if let image = recipe.imageURL {
                                    KFImage(URL(string: image))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 172, height: 132)
                                        .clipShape(.rect(cornerRadius: 16))
                                }
                                
                                if let title = recipe.title {
                                    Text(title)
                                        .font(.headline)
                                        .foregroundStyle(.atlasDark)
                                        .lineLimit(0)
                                }
                                
                                if let flag = recipe.flagEmoji,
                                   let cookTime = recipe.cookTimeMinutes {
                                    Text("\(flag) \(cookTime) minutes")
                                        .font(.subheadline)
                                        .foregroundStyle(.atlasGray)
                                }
                                
                                Text(recipe.difficultyText)
                                    .font(.caption.bold())
                                    .foregroundStyle(Color(recipe.difficultyColor))
                            }
                        }
                    }
                    .padding()
                    .background(.white, in: .rect(cornerRadius: 20))
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
