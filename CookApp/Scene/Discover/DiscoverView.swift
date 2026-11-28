//
//  DiscoverView.swift
//  CookApp
//
//  Created by Javid Sultanov on 10.11.26.
//

import SwiftUI

struct DiscoverView: View {
    @State private var viewModel = DiscoverViewModel()
    
    var settingsTapped: (() -> Void)?
    var recipeTapped: ((Int) -> Void)?
    var cuisineTapped: ((Cuisine) -> Void)?
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
                    .tint(.atlasOrange)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .loaded:
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        PickedSection(recipes: viewModel.pickedRecipes,
                                      recipeTapped: recipeTapped)
                        CuisineSection(cuisines: viewModel.favoriteCuisines,
                                       cuisineTapped: cuisineTapped)
                        RecommendedSection(viewModel: viewModel,
                                           recipeTapped: recipeTapped)
                    }
                    .padding(.horizontal)
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
        .background(.atlasCream)
        .toolbar {
            Button {
                settingsTapped?()
            } label: {
                Image(systemName: "gearshape")
            }
        }
        .task {
            await viewModel.getDiscoverData()
        }
    }
}

#Preview {
    TabBarController()
}
