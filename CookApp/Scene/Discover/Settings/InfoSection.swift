//
//  InfoSection.swift
//  CookApp
//
//  Created by Javid Sultanov on 28.11.26.
//

import SwiftUI

struct InfoSection: View {
    let recipeCount: Int
    let cuisineCount: Int
    
    var body: some View {
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
                    Text("\(recipeCount) recipes from \(cuisineCount) cuisines, served by the CookAtlas API. Videos open in YouTube.")
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
}
