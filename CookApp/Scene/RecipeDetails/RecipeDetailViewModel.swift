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
    
    var success: (() -> Void)?
    var error: ((String) -> Void)?
    
    var ingredients: [RecipeIngredient] {
        recipeDetail?.ingredients ?? []
    }
    
    var steps: [String] {
        recipeDetail?.steps ?? []
    }
    
    var youtubeLink: String {
        if let link = recipeDetail?.youtubeURL, !link.isEmpty {
            return link
        }
        
        let title = recipeDetail?.title?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "https://www.youtube.com/results?search_query=\(title)+recipe"
    }
    
    func getRecipeDetail() {
        manager.getRecipeDetails(id: id) { data, errorMessage in
            if let errorMessage {
                self.error?(errorMessage)
            } else if let data {
                self.recipeDetail = data.first
                self.success?()
            }
        }
    }
    
    func getSavedRecipes() {
        dataBaseManager.getRecipes()
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
        dataBaseManager.fetchCallback = { recipes in
            self.isSaved = recipes.contains(where: { Int($0.recipeID) == self.id })
            self.success?()
        }
        
        dataBaseManager.saveCallback = { recipeDetail in
            self.isSaved = true
            self.success?()
        }
        
        dataBaseManager.deleteCallback = { recipeDetailID in
            self.isSaved = false
            self.success?()
        }
        
        dataBaseManager.errorCallback = { errorMessage in
            self.error?(errorMessage)
        }
    }
}
