//
//  CatCollectionViewController.swift
//  CatList
//
//  Created by Nitesh Tak on 23/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import UIKit
import GiniKit

class CatCollectionViewController: UICollectionViewController {
    
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
    
    var cats = [Cat]()

    override func viewDidLoad() {
        super.viewDidLoad()



        self.title = "Cat list"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        apiService.getCats { [weak self] cats in
            if let cats = cats as? [Cat] {
                self?.cats = cats
                self?.collectionView.reloadData()
            }
        }
            
        
        //        apiService.addFovourite(with: ["image_id": "shYPuXahD", "sub_id": "nitesh-1"]) {_ in
        //            print("Success")
        //        }
        

//
//
//
//        apiService.getFavorites() { cats in
//            print(cats ?? [])
//        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // adjust layout item size to fit new width
        //itemSize = CGSize(width: (view.bounds.width / 2) - 10, height: (view.bounds.width / 2) - 10)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: Data Source
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionCell", for: indexPath) as! CatCollectionCell
        
        let cat = self.cats[indexPath.row]
        cell.catImageView?.imageURL = URL(string: cat.url) ?? nil
        
        return cell
    }
    
    //MARK: Delegates
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowFavorites", sender: self)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cats.count
    }

}

extension CatCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width / 2) - 10, height: (view.bounds.width / 2))
    }
}
