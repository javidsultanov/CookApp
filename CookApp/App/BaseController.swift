//
//  BaseController.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import UIKit

class BaseController: UIViewController {
    let loadingView = UIActivityIndicatorView.loadingView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureConstraints()
        configureViewModel()
    }
    
    func configureUI() {}
    
    func configureConstraints() {}
    
    func configureViewModel() {}
    
    func startLoading() {
        view.addSubview(loadingView)
        loadingView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        loadingView.startAnimating()
    }
    
    func stopLoading() {
        loadingView.stopAnimating()
    }
    
    func configureState() {}
}
