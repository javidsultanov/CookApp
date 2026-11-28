//
//  SearchSection.swift
//  CookApp
//
//  Created by Javid Sultanov on 28.11.26.
//

import SwiftUI

struct SearchSection: View {
    @Bindable var viewModel: AIHelpViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What do you have?")
                .font(.title2.bold())
                .foregroundStyle(.atlasDark)
            
            TextField("your ingredients", text: $viewModel.text, axis: .vertical)
                .foregroundStyle(.atlasGray)
                .padding()
                .background(.white, in: .buttonBorder)
                        
            Picker("Time", selection: $viewModel.maxMinutes) {
                Text("20 minutes").tag(20)
                Text("40 minutes").tag(40)
                Text("1 hour").tag(60)
                Text("Any").tag(10000)
            }
            
            Button {
                Task {
                    await viewModel.getAIHelp()
                }
            } label: {
                Label("Find Recipes", systemImage: "sparkles")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.atlasOrange)
            .disabled(viewModel.text.isEmpty || viewModel.resultState == .loading)
        }
    }
}
