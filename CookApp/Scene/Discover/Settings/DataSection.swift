//
//  DataSection.swift
//  CookApp
//
//  Created by Javid Sultanov on 28.11.26.
//

import SwiftUI

struct DataSection: View {
    let savedText: String
    
    var body: some View {
        Section("Your Data") {
            HStack {
                Image(systemName: "iphone")
                    .foregroundStyle(.blue)
                
                Text("On this iPhone")
                    .foregroundStyle(.atlasDark)
                Spacer()
                Text(savedText)
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
    }
}
