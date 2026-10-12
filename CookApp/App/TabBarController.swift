//
//  TabBarController.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        let discoverController = DiscoverController()
        discoverController.tabBarItem = .init(title: "Discover",
                                              image: .init(systemName: "safari"),
                                              tag: 0)
        let discoverNavigation = UINavigationController(rootViewController: discoverController)
        
        let recipesController = RecipesController()
        recipesController.tabBarItem = .init(title: "Recipes",
                                             image: .init(systemName: "fork.knife"),
                                             tag: 0)
        let recipesNavigation = UINavigationController(rootViewController: recipesController)
        
        let cuisinesController = CuisinesController()
        cuisinesController.tabBarItem = .init(title: "Cuisines",
                                              image: .init(systemName: "globe"),
                                              tag: 0)
        let cuisinesNavigation = UINavigationController(rootViewController: cuisinesController)
        
        let ingredientsController = IngredientsController()
        ingredientsController.tabBarItem = .init(title: "Ingredients",
                                                 image: .init(systemName: "leaf"),
                                                 tag: 0)
        let ingredientsNavigation = UINavigationController(rootViewController: ingredientsController)
        
        let cookbookController = CookbookController()
        cookbookController.tabBarItem = .init(title: "Cookbook",
                                              image: .init(systemName: "text.book.closed"),
                                              tag: 0)
        let cookbookNavigation = UINavigationController(rootViewController: cookbookController)
        
        viewControllers = [discoverNavigation, recipesNavigation, cuisinesNavigation, ingredientsNavigation, cookbookNavigation]
    }
}
