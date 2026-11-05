//
//  RecipeDetailController.swift
//  CookApp
//
//  Created by Javid Sultanov on 05.11.26.
//

import UIKit

class RecipeDetailController: BaseController {
    
    private let viewModel: RecipeDetailViewModel
    
    init(viewModel: RecipeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
