//
//  Difficulty.swift
//  CookApp
//
//  Created by Javid Sultanov on 12.10.26.
//

import Foundation
import UIKit

protocol DifficultyProtocol {
    var difficultyText: String { get }
    var difficultyColor: UIColor { get }
}

enum Difficulty: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var color: UIColor {
        switch self {
        case .easy:
            return .systemGreen
        case .medium:
            return .systemOrange
        case .hard:
            return .systemRed
        }
    }
}
