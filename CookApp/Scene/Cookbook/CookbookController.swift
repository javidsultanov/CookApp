//
//  CookbookController.swift
//  CookApp
//
//  Created by Javid Sultanov on 13.10.26.
//

import UIKit

class CookbookController: BaseController {
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CuisineRecipesCell.self, forCellWithReuseIdentifier: "\(CuisineRecipesCell.self)")
//        collection.delegate = self
//        collection.dataSource = self
        
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        navigationItem.title = "Cookbook"
    }
}

//extension CookbookController: CollectionConfiguration {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//    
//    
//}
