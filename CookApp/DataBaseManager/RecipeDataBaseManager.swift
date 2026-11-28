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
    
    var saveCallback: ((Int) -> Void)?
    var deleteCallback: ((Int) -> Void)?
    var errorCallback: ((String) -> Void)?
    
    func getSavedRecipes() -> [SavedRecipe] {
        let entities = (try? context.fetch(RecipeEntity.fetchRequest())) ?? []
        return entities.map({ makeSavedRecipe(entity: $0) })
    }
    
    func isSaved(recipeID: Int) -> Bool {
        let request = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %d", recipeID)
        
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }
    
    func saveRecipe(recipe: RecipeCard) {
        guard let id = recipe.id, !isSaved(recipeID: id) else { return }
            
            let recipeEntity = RecipeEntity(context: context)
            recipeEntity.recipeID = Int64(id)
            recipeEntity.recipeImage = recipe.imageURL
            recipeEntity.recipeTitle = recipe.title
            recipeEntity.recipeFlag = recipe.flagEmoji
            recipeEntity.recipeMinutes = Int64(recipe.cookTimeMinutes ?? 0)
            recipeEntity.cuisineTitle = recipe.cuisineName
        
        saveContext(recipeID: id)
    }
    
    func saveRecipeDetail(detail: RecipeDetail) {
        guard let id = detail.id, !isSaved(recipeID: id) else { return }
        
            let recipeEntity = RecipeEntity(context: context)
            recipeEntity.recipeID = Int64(id)
            recipeEntity.recipeImage = detail.imageURL
            recipeEntity.recipeTitle = detail.title
            recipeEntity.recipeFlag = detail.cuisine?.flagEmoji
            recipeEntity.recipeMinutes = Int64(detail.cookTimeMinutes ?? 0)
            recipeEntity.cuisineTitle = detail.cuisine?.name
        
        saveContext(recipeID: id)
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
    
    func saveContext(recipeID: Int) {
        do {
            try context.save()
            saveCallback?(recipeID)
        } catch {
            errorCallback?(error.localizedDescription)
        }
    }
    
    func makeSavedRecipe(entity: RecipeEntity) -> SavedRecipe {
        SavedRecipe(id: Int(entity.recipeID),
                    title: entity.recipeTitle,
                    imageURL: entity.recipeImage,
                    flagEmoji: entity.recipeFlag,
                    cuisineName: entity.cuisineTitle,
                    cookTimeMinutes: Int(entity.recipeMinutes))
    }
}
