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
<<<<<<< Updated upstream
        let discoverController = DiscoverController()
        discoverController.tabBarItem = .init(title: "Discover",
                                              image: .init(systemName: "safari"),
                                              tag: 0)
        let discoverNavigation = UINavigationController(rootViewController: discoverController)
=======
        let discoverView = UIHostingController(rootView: DiscoverView(settingsTapped: { [weak self] in
            let settingsView = UIHostingController(rootView: SettingsView())
            settingsView.hidesBottomBarWhenPushed = true
            (self?.selectedViewController as? UINavigationController)?.pushViewController(settingsView, animated: true)
        }, recipeTapped: { [weak self] id in
            self?.openReccipeDetail(id: id)
        }, cuisineTapped: { [weak self] cuisine in
            self?.openCuisineRecipes(cuisine: cuisine)
        }))
        discoverView.navigationItem.title = "Discover"
        discoverView.tabBarItem = .init(title: "Discover",
                                        image: .init(systemName: "safari"),
                                        tag: 0)
        let discoverNavigation = UINavigationController(rootViewController: discoverView)
>>>>>>> Stashed changes
        
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
    
    private func openReccipeDetail(id: Int) {
        guard let navigationController = selectedViewController as? UINavigationController else { return }
        
        let coordinator = RecipeDetailCoordinator(navigationController: navigationController, id: id)
        coordinator.start()
    }
    
    private func openCuisineRecipes(cuisine: Cuisine) {
        guard let navigationController = selectedViewController as? UINavigationController else { return }
        
        let coordinator = CuisineRecipesCoordinator(navigationController: navigationController, cuisine: cuisine)
        coordinator.start()
    }
}
