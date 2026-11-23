//
//  RecipeDetailCoordinator.swift
//  CookApp
//
//  Created by Javid Sultanov on 05.11.26.
//

import Foundation
import UIKit

class RecipeDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var id: Int
    
    init(navigationController: UINavigationController, id: Int) {
        self.navigationController = navigationController
        self.id = id
    }
    
    func start() {
        let controller = RecipeDetailController(viewModel: .init(id: id))
        controller.hidesBottomBarWhenPushed = true
        navigationController.show(controller, sender: nil)
    }
}
