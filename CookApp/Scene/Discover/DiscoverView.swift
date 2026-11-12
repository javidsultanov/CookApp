//
//  DiscoverView.swift
//  CookApp
//
//  Created by Javid Sultanov on 10.11.26.
//

import SwiftUI

struct DiscoverView: View {
    
    var body: some View {
        Text("Discover")
            .toolbar {
                NavigationLink {
                    SettingsView()
                } label: {
                    Image(systemName: "gearshape")
                }
            }
    }
}

#Preview {
    TabBarController()
}
