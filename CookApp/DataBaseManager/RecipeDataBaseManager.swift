//
//  RecipeDataBaseManager.swift
//  CookApp
//
//  Created by Javid Sultanov on 31.10.26.
//

import Foundation
import CoreData
import UIKit

class RecipeDataBaseManager {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var saveCallback: ((RecipeEntity) -> Void)?
    var deleteCallback: ((Int) -> Void)?
    var errorCallback: ((String) -> Void)?
    
    func getSavedRecipes() -> [RecipeEntity] {
        let savedRecipes = try? context.fetch(RecipeEntity.fetchRequest())
        return savedRecipes ?? []
    }
    
    func isSaved(recipeID: Int) -> Bool {
        let request = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %d", recipeID)
        
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }
    
    func saveRecipe(recipe: RecipeCard) {
        if isSaved(recipeID: recipe.id ?? 0) { return }
            
            let recipeEntity = RecipeEntity(context: context)
            recipeEntity.recipeID = Int64(recipe.id ?? 0)
            recipeEntity.recipeImage = recipe.imageURL
            recipeEntity.recipeTitle = recipe.title
            recipeEntity.recipeFlag = recipe.flagEmoji
            recipeEntity.recipeMinutes = Int64(recipe.cookTimeMinutes ?? 0)
            recipeEntity.cuisineTitle = recipe.cuisineName
            
        do {
            try context.save()
            saveCallback?(recipeEntity)
        } catch {
            errorCallback?(error.localizedDescription)
        }
    }
    
    func saveRecipeDetail(detail: RecipeDetail) {
        if isSaved(recipeID: detail.id ?? 0) { return }
            
            let recipeEntity = RecipeEntity(context: context)
            recipeEntity.recipeID = Int64(detail.id ?? 0)
            recipeEntity.recipeImage = detail.imageURL
            recipeEntity.recipeTitle = detail.title
            recipeEntity.recipeFlag = detail.cuisine?.flagEmoji
            recipeEntity.recipeMinutes = Int64(detail.cookTimeMinutes ?? 0)
            recipeEntity.cuisineTitle = detail.cuisine?.name
            
        do {
            try context.save()
            saveCallback?(recipeEntity)
        } catch {
            errorCallback?(error.localizedDescription)
        }
    }
    
    func deleteRecipe(recipeID: Int) {
        let request = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %d", recipeID)
        
        do {
            let recipes = try context.fetch(request)
            
            for recipe in recipes {
                context.delete(recipe)
            }
            
            try context.save()
            deleteCallback?(recipeID)
        } catch {
            errorCallback?(error.localizedDescription)
        }
    }
}
