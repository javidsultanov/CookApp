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
        view.backgroundColor = UIColor(red: 251/255, green: 244/255, blue: 234/255, alpha: 1)
        
        configureUI()
        configureConstraints()
        configureViewModel()
    }
    
    func configureUI() {}
    
    func configureConstraints() {}
    
    func configureViewModel() {}
}
