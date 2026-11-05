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
    
    var fetchCallback: (([RecipeEntity]) -> Void)?
    var saveCallback: ((RecipeEntity) -> Void)?
    var deleteCallback: ((Int) -> Void)?
    var errorCallback: ((String) -> Void)?
    
    func getRecipes() {
        do {
            let recipes = try context.fetch(RecipeEntity.fetchRequest())
            fetchCallback?(recipes)
        } catch {
            errorCallback?(error.localizedDescription)
        }
    }
    
    func saveRecipe(recipe: RecipeCard) {
        let request = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %d", recipe.id ?? 0)
        
        do {
            let count = try context.count(for: request)
            
            if count > 0 { return }
            if count > 0 {
                return
            }
            
            let recipeEntity = RecipeEntity(context: context)
            recipeEntity.recipeID = Int64(recipe.id ?? 0)
            recipeEntity.recipeImage = recipe.imageURL
            recipeEntity.recipeTitle = recipe.title
            recipeEntity.recipeFlag = recipe.flagEmoji
            recipeEntity.recipeMinutes = Int64(recipe.cookTimeMinutes ?? 0)
            recipeEntity.cuisineTitle = recipe.cuisineName
            
            try context.save()
            saveCallback?(recipeEntity)
        } catch {
            errorCallback?(error.localizedDescription)
        }
    }
    
    func saveRecipeDetail(detail: RecipeDetail) {
        let request = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipeID == %d", detail.id ?? 0)
        
        do {
            let count = try context.count(for: request)
            
            if count > 0 { return }
            
            let recipeEntity = RecipeEntity(context: context)
            recipeEntity.recipeID = Int64(detail.id ?? 0)
            recipeEntity.recipeImage = detail.imageURL
            recipeEntity.recipeTitle = detail.title
            recipeEntity.recipeFlag = detail.cuisine?.flagEmoji
            recipeEntity.recipeMinutes = Int64(detail.cookTimeMinutes ?? 0)
            recipeEntity.cuisineTitle = detail.cuisine?.name
            
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
