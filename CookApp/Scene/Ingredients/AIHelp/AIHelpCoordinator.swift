//
//  AIHelpCoordinator.swift
//  CookApp
//
//  Created by Javid Sultanov on 27.11.26.
//

import Foundation
import UIKit
import SwiftUI

class AIHelpCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let helpView = AIHelpView { id in
            let coordinator = RecipeDetailCoordinator(navigationController: self.navigationController, id: id)
            coordinator.start()
        }
        
        let controller = UIHostingController(rootView: helpView)
        controller.hidesBottomBarWhenPushed = true
        navigationController.show(controller, sender: self)
    }
}
