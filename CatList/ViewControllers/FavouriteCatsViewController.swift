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
            layout.sectionInset = UIEdgeInsets(top: 1, left: 5, bottom: 1, right: 0)
            layout.itemSize = itemSize
            layout.invalidateLayout()
        }
    }
    
    let apiService = APIService.shared
    
    var selectedFavourite: Favorite?
    var favorites = [Favorite]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Favourite"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiService.getFavorites() { [weak self] cats in
            if let cats = cats as? [Favorite] {
                self?.favorites = cats
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // adjust layout item size to fit new width
        itemSize = CGSize(width: (view.bounds.width - 10)/2, height: (view.bounds.width / 2))
    }
    
    // MARK: - Navigatio
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFavouriteDetail" {
            let vc = segue.destination as! CatDetailViewController
            vc.favourite = selectedFavourite
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
    
        let favourite = self.favorites[indexPath.row]
        cell.catImageView?.imageURL = URL(string: favourite.image.url) ?? nil
    
        return cell
    }
    
    //MARK: Delegates
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFavourite = self.favorites[indexPath.row]
        self.performSegue(withIdentifier: "ShowFavouriteDetail", sender: self)
    }
}

extension FavouriteCatsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width - 10)/2, height: (view.bounds.width / 2))
    }
}

