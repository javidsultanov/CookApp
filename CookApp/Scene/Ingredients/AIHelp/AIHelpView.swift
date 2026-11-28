//
//  AIHelpView.swift
//  CookApp
//
//  Created by Javid Sultanov on 24.11.26.
//

import SwiftUI

struct AIHelpView: View {
    @State private var viewModel = AIHelpViewModel()
    
    var recipeTapped: ((Int) -> Void)?
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .idle, .loading:
                ProgressView()
                    .tint(.atlasOrange)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                
            case .loaded:
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            SearchSection(viewModel: viewModel)
                            ResultSection(viewModel: viewModel,
                                          recipeTapped: recipeTapped)
                        }
                        .padding()
                    }
                
            case .error(let errorMessage):
                ContentUnavailableView("AI Help is not available",
                                       systemImage: "exclamationmark.triangle",
                                       description: Text(errorMessage))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.atlasCream)
        .navigationTitle("AI Help")
    }
}

#Preview {
    UINavigationController(rootViewController: UIHostingController(rootView: AIHelpView()))
}
