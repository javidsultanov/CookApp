//
//  RecipeDetailViewModel.swift
//  CookApp
//
//  Created by Javid Sultanov on 05.11.26.
//

import Foundation

class RecipeDetailViewModel {
    var manager: RecipeManagerUseCase
    var id: Int
    
    init(manager: RecipeManagerUseCase = RecipeManager(), id: Int) {
        self.manager = manager
        self.id = id
        configureDataBaseManager()
    }
    
    var recipeDetail: RecipeDetail?
    var isSaved = false
    
    private let dataBaseManager = RecipeDataBaseManager()
    
    let sections = RecipeDetailSection.allCases
        
    var stateChanged: (() -> Void)?
    
    private(set) var state: ViewState = .idle {
        didSet {
            stateChanged?()
        }
    }
    
    var ingredients: [RecipeIngredient] {
        recipeDetail?.ingredients ?? []
    }
    
    var steps: [String] {
        recipeDetail?.steps ?? []
    }
    
    var youtubeLink: URL? {
        guard let link = recipeDetail?.youtubeURL, !link.isEmpty else {
            let title = recipeDetail?.title?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return URL(string: "https://www.youtube.com/results?search_query=\(title)+recipe")
        }
        return URL(string: link)
    }
    
    func getRecipeDetail() {
        state = .loading
                
        Task {
            do {
                let data = try await manager.getRecipeDetails(id: id)
                recipeDetail = data.first
                
                state = .loaded
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    func checkSaved() {
        isSaved = dataBaseManager.isSaved(recipeID: id)
        stateChanged?()
    }
    
    func saveButtonTapped() {
        guard let recipeDetail else { return }
        
        if isSaved {
            dataBaseManager.deleteRecipe(recipeID: id)
        } else {
            dataBaseManager.saveRecipeDetail(detail: recipeDetail)
        }
    }
    
    private func configureDataBaseManager() {
        dataBaseManager.saveCallback = { recipeDetail in
            self.isSaved = true
            self.stateChanged?()
        }
        
        dataBaseManager.deleteCallback = { recipeDetailID in
            self.isSaved = false
            self.stateChanged?()
        }
        
        dataBaseManager.errorCallback = { errorMessage in
            self.state = .error(errorMessage)
        }
    }
}
