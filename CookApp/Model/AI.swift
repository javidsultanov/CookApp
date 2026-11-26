//
//  AI.swift
//  CookApp
//
//  Created by Javid Sultanov on 24.11.26.
//

import Foundation
import FoundationModels

@Generable()
struct IngredientsHandler {
    @Guide(description: "Ingredient names from the catalog that the user has")
    var names: [String]
}

@Generable()
struct RecipePicker {
    @Guide(description: "The id of a recipe from the list")
    var recipeID: Int
    
    @Guide(description: "One short sentence why this recipe fits")
    var reason: String
}

@Generable()
struct RecipeFavourite {
    @Guide(description: "The best recipes for the user", .maximumCount(3))
    var picks: [RecipePicker]
}
