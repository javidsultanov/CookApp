//
//  RecipeEntity+CoreDataProperties.swift
//  CookApp
//
//  Created by Javid Sultanov on 02.11.26.
//
//

public import Foundation
public import CoreData


public typealias RecipeEntityCoreDataPropertiesSet = NSSet

extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged nonisolated public var recipeImage: String?
    @NSManaged nonisolated public var recipeTitle: String?
    @NSManaged nonisolated public var recipeFlag: String?
    @NSManaged nonisolated public var recipeID: Int64
    @NSManaged nonisolated public var cuisineTitle: String?
    @NSManaged nonisolated public var recipeMinutes: Int64

}

extension RecipeEntity : Identifiable {

}
