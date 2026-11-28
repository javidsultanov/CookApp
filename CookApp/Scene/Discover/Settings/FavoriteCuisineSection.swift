//
//  FavoriteCuisineSection.swift
//  CookApp
//
//  Created by Javid Sultanov on 28.11.26.
//

import SwiftUI

struct FavoriteCuisineSection: View {
    let viewModel: SettingViewModel
    
    var body: some View {
        Section("Favorite Cuisines") {
            ForEach(viewModel.cuisines, id: \.id) { cuisine in
                Button {
                    viewModel.toggleFavorite(cuisine: cuisine)
                } label: {
                    HStack {
                        if let flag = cuisine.flagEmoji {
                            Text(flag)
                        }
                        
                        if let name = cuisine.name {
                            Text(name)
                        }
                        Spacer()
                        if viewModel.isFavorite(cuisine: cuisine) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.atlasOrange)
                        }
                    }
                }
                .foregroundStyle(.atlasDark)
            }
        }
    }
}
