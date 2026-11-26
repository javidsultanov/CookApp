//
//  AppFont.swift
//  CookApp
//
//  Created by Javid Sultanov on 27.11.26.
//

import Foundation
import UIKit
import SwiftUI

enum AppFont {
    case largeTitle
    case title
    case sectionTitle
    case headline
    case body
    case subheadline
    case captionBold
    case caption
    
    var size: CGFloat {
        switch self {
        case .largeTitle: return 32
        case .title: return 24
        case .sectionTitle: return 20
        case .headline, .body: return 16
        case .subheadline: return 14
        case .captionBold, .caption: return 12
        }
    }

    var weight: UIFont.Weight {
        switch self {
        case .largeTitle, .title, .sectionTitle, .headline, .captionBold:
            return .bold
        case .body, .subheadline, .caption:
            return .regular
        }
    }

    // UIKit
    var uiFont: UIFont {
        .systemFont(ofSize: size, weight: weight)
    }

    // SwiftUI
    var font: Font {
        Font(uiFont as CTFont)
    }
}
