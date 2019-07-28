//
//  FavouriteCatsViewController.swift
//  
//
//  Created by Nitesh Tak on 28/7/19.
//

import UIKit
import GiniKit

class FavouriteCatsViewController: UICollectionViewController {
    
    var itemSize: CGSize = .zero {
        didSet {
            guard oldValue != itemSize else { return }
            guard let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.minimumInteritemSpacing = 0.5
            layout.minimumLineSpacing = 0.5
            layout.sectionInset = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 5)
            layout.itemSize = itemSize
            layout.invalidateLayout()
        }
    }
    
    let apiService = APIService.shared
    
    var favorites = [Cat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Favourite"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiService.getFavorites() { [weak self] cats in
            if let cats = cats as? [Cat] {
                self?.favorites = cats
                self?.collectionView.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.favorites.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionCell", for: indexPath) as! CatCollectionCell
    
        let cat = self.favorites[indexPath.row]
        cell.catImageView?.imageURL = URL(string: cat.url) ?? nil
    
        return cell
    }
}
