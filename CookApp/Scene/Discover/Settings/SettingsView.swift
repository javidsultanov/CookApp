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
                    FavoriteCuisineSection(viewModel: viewModel)
                    DataSection(savedText: viewModel.savedText)
                    InfoSection(recipeCount: viewModel.recipeCount,
                                cuisineCount: viewModel.cuisines.count)
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
