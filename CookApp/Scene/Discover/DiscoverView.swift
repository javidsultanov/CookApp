//
//  DiscoverView.swift
//  CookApp
//
//  Created by Javid Sultanov on 10.11.26.
//

import SwiftUI

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
