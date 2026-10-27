//
//  BaseController.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import UIKit

class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .atlasCream
        
        configureUI()
        configureConstraints()
        configureViewModel()
    }
    
    func configureUI() {}
    
    func configureConstraints() {}
    
    func configureViewModel() {}
}
