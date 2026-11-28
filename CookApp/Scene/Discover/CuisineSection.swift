//
//  CuisineSection.swift
//  CookApp
//
//  Created by Javid Sultanov on 28.11.26.
//

import SwiftUI

struct CuisineSection: View {
    let cuisines: [Cuisine]
    var cuisineTapped: ((Cuisine) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Cuisines:")
                .font(.title2.bold())
                .foregroundStyle(.atlasGray)
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(100))], spacing: 12) {
                    ForEach(cuisines, id: \.id) { cuisine in
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
}
