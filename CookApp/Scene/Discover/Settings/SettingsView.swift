//
//  SettingsView.swift
//  CookApp
//
//  Created by Javid Sultanov on 10.11.26.
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingViewModel()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()
                    .tint(.atlasOrange)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .loaded:
                List {
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
                    
                    Section("Your Data") {
                        HStack {
                            Image(systemName: "iphone")
                                .foregroundStyle(.blue)
                            
                            Text("On this Iphone")
                                .foregroundStyle(.atlasDark)
                            Spacer()
                            Text(viewModel.savedText)
                                .font(.caption)
                                .foregroundStyle(.atlasGray)
                        }
                        
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.blue)
                            
                            VStack(alignment: .leading) {
                                Text("No account needed")
                                    .foregroundStyle(.atlasDark)
                                Text("Saved recipes stay on this phone. Deleting the App removes them.")
                                    .font(.caption)
                                    .foregroundStyle(.atlasGray)
                            }
                        }
                    }
                    
                    Section("About") {
                        HStack {
                            Text("CookAtlas")
                                .foregroundStyle(.atlasDark)
                            Spacer()
                            Text("Version 1.0")
                                .font(.caption)
                                .foregroundStyle(.atlasGray)
                        }
                        
                        HStack {
                            Image(systemName: "server.rack")
                                .foregroundStyle(.blue)
                            
                            VStack(alignment: .leading) {
                                Text("Recipe Data")
                                    .foregroundStyle(.atlasDark)
                                Text("\(viewModel.recipeCount) recipes from \(viewModel.cuisines.count) cuisines, served by the CookAtlas API. Videos open in YouTube.")
                                    .font(.caption)
                                    .foregroundStyle(.atlasGray)
                            }
                        }
                    }
                    
                    VStack {
                        Text("C.C. · Cool Coding programs")
                            .foregroundStyle(.atlasDark)
                        Text("Forged at SAS Tech Academy")
                            .foregroundStyle(.atlasGray)
                    }
                    .font(.footnote.bold())
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
                
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
        .navigationTitle("Settings")
        .task {
            await viewModel.getCuisines()
        }
        .onAppear {
            viewModel.getSavedCount()
        }
    }
}

#Preview {
    UINavigationController(rootViewController: UIHostingController(rootView: SettingsView()))
}
