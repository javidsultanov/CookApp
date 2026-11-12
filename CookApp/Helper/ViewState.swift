//
//  ViewState.swift
//  CookApp
//
//  Created by Javid Sultanov on 10.11.26.
//

import Foundation

enum ViewState {
    case idle
    case loading
    case loaded
    case error(String)
}
