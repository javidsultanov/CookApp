//
//  DiscoverView.swift
//  CookApp
//
//  Created by Javid Sultanov on 10.11.26.
//

import SwiftUI
import Kingfisher

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
                        Text("What would you like to cook today?")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.atlasDark)
                            .padding(.vertical)
                        
                        pickedSection
                        cuisineSection
                        recommendedSection
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
    
    
    private var pickedSection: some View {
        VStack(alignment: .leading) {
            Text("Picked for You:")
                .font(.title2.bold())
                .foregroundStyle(.atlasGray)
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(200))], spacing: 8) {
                    ForEach(viewModel.pickedRecipes, id: \.id) { recipe in
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
    
    
    private var cuisineSection: some View {
        VStack(alignment: .leading) {
            Text("Your Cuisines:")
                .font(.title2.bold())
                .foregroundStyle(.atlasGray)
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(100))], spacing: 12) {
                    ForEach(viewModel.favoriteCuisines, id: \.id) { cuisine in
                        Button {
                            cuisineTapped?(cuisine)
                        } label: {
                            VStack(spacing: 8) {
                                if let flag = cuisine.flagEmoji {
                                    Text(flag)
                                        .font(.system(size: 48))
                                        .frame(width: 68, height: 56)
                                        .background(.white, in: .rect(cornerRadius: 12))
                                }
                                
                                if let name = cuisine.name {
                                    Text(name)
                                        .font(.caption.bold())
                                        .foregroundStyle(.atlasDark)
                                        .lineLimit(0)
                                }
                            }
                        }
                        .frame(width: 76)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
    
    
    private var recommendedSection: some View {
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
                    Label("New", systemImage: "arrow.clockwise")
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

struct DiscoverView: View {
    
    var settingButtonAction: (() -> Void)?
        
    var body: some View {
        Text("Discover")
            .toolbar {
                Button {
                    settingButtonAction?()
                } label: {
                    Image(systemName: "gearshape")
                }
            }
    }
}

#Preview {
    TabBarController()
}
