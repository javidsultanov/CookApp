//
//  View+AppStyle.swift
//  CookApp
//
//  Created by Javid Sultanov on 27.11.26.
//

import Foundation
import SwiftUI

extension View {
    func appFont(_ font: AppFont, color: Color = .atlasDark) -> some View {
        self
            .font(font.font)
            .foregroundStyle(color)
    }

    func cardStyle(radius: CGFloat = AppRadius.xl) -> some View {
        self
            .padding(AppSpacing.l)
            .background(.white, in: .rect(cornerRadius: radius))
    }
}
