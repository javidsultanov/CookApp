//
//  OnboardingViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 16.10.26.
//

import Foundation

final class OnboardingViewModel {
    var manager: CuisineManagerUseCase
    var cuisines: [Cuisine] = []
    var selectedCuisineID: [Int]
    
    let feauter: [Feature] = [.init(image: "bookmark.fill",
                                    title: "Save recipes you like",
                                    description: "Keep them in your Cookbook and find them in one tap."),
                              .init(image: "leaf.fill",
                                    title: "Cook with what you have",
                                    description: "Pick an ingredient, like eggs or chicken, and see every recipe that uses it."),
                              .init(image: "stairs",
                                    title: "Cook step by step",
                                    description: "Follow one clear step at a time, then rate how the dish turned out.")]
    
    var stateChanged: (() -> Void)?
    
    private(set) var state: ViewState = .idle {
        didSet {
            stateChanged?()
        }
    }

    var nextCallback: (() -> Void)?
    var finishCallback: (() -> Void)?
    
    var currentIndex = 0
    let pages = OnboardingPage.allCases

    init(manager: CuisineManagerUseCase = CuisineManager()) {
        self.manager = manager
        self.selectedCuisineID = UserDefaultsHelper.shared.favoriteCuisinesID
    }
    
    func getCuisines() {
        state = .loading
        
        manager.getCuisines { data, errorMessage in
            if let errorMessage {
                self.state = .error(errorMessage)
            } else if let data {
                self.cuisines = data
                
                if self.selectedCuisineID.isEmpty,
                   let firstCuisine = self.cuisines.first {
                    self.selectedCuisineID.append(firstCuisine.id ?? 0)
                }
                
                self.state = .loaded
            }
        }
    }
    
    func toggleSelection(index: Int) {
        let id = cuisines[index].id ?? 0
        if let selectedIndex = selectedCuisineID.firstIndex(of: id) {
            selectedCuisineID.remove(at: selectedIndex)
        } else {
            selectedCuisineID.append(id)
        }
    }
    
    var countText: String {
        if selectedCuisineID.isEmpty {
            return "Choose your favorite Cuisine"
        } else if selectedCuisineID.count == 1 {
            return "1 Cuisine selected"
        } else {
            return "\(selectedCuisineID.count) Cuisines selected"
        }
    }
    
    var buttonText: String {
        switch pages[currentIndex] {
        case .welcome:
            return "Get Started"
        case .cuisines:
            return "Continue"
        case .journey:
            return "Explore CookAtlas"
        }
    }
    
    func nextPage() {
        if pages[currentIndex] == .journey {
            completeOnboarding()
        } else {
            currentIndex += 1
            nextCallback?()
        }
    }
    
    func completeOnboarding() {
        UserDefaultsHelper.shared.hasSeenOnboarding = true
        UserDefaultsHelper.shared.favoriteCuisinesID = selectedCuisineID
        finishCallback?()
    }
}
