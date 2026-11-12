//
//  SettingsView.swift
//  CookApp
//
//  Created by Javid Sultanov on 10.11.26.
//

import SwiftUI

struct SettingsView: View {
    @State private var viewModel = SettingViewModel()
    private var tabBar: UITabBarController? {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.rootViewController as? UITabBarController
    }
    
    var body: some View {
        List {
            Section("Favorite Cuisines") {
                switch viewModel.state {
                case .idle, .loading:
                    ProgressView()
                    
                case .loaded:
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
                    
                case .error(let errorMessage):
                    Text(errorMessage)
                }
            }
            
            Section("Your Data") {
                HStack {
                    Image(systemName: "iphone")
                        .foregroundStyle(.blue)
                    
                    Text("On this Iphone")
                        .foregroundStyle(.atlasDark)
                    Spacer()
                    Text("\(viewModel.savedCount) saved recipes")
                        .font(.caption)
                        .foregroundStyle(.atlasGray)
                }
                
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color.blue)
                    
                    VStack(alignment: .leading) {
                        Text("No account needed")
                            .foregroundStyle(.atlasDark)
                        Text("Saved recipes stay on this Iphone. Deleting the App removes them.")
                            .font(.caption)
                            .foregroundStyle(.atlasGray)
                    }
                }
            }
            
            Section("About") {
                HStack {
                    Text("CookAtlas")
                        .foregroundStyle(Color.atlasDark)
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
        .background(.atlasCream)
        .navigationTitle("Settings")
        .onAppear {
            viewModel.getCuisines()
            viewModel.getSavedCount()
            tabBar?.setTabBarHidden(true, animated: false)
        }
        .onDisappear {
            tabBar?.setTabBarHidden(false, animated: true)
        }
    }
}

#Preview {
    UINavigationController(rootViewController: UIHostingController(rootView: SettingsView()))
}
