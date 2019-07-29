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
    
    var didSelect: (Cat) -> () = { _ in }
    
    var page: Int = 0
    
    var itemSize: CGSize = .zero {
        didSet {
            guard oldValue != itemSize else { return }
            guard let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
            layout.minimumInteritemSpacing = 0.0
            layout.minimumLineSpacing = 0.0
            layout.sectionInset = UIEdgeInsets(top: 1, left: 3, bottom: 1, right: 3)
            layout.itemSize = itemSize
            layout.invalidateLayout()
        }
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal var apiService: APIServiceProtocol! = APIService.shared

    var cats = [Cat]()
    
    var seletedCat: Cat?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cat list"
        
        self.collectionView.registerSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, LoadingFooterView.self)
        
        getCatList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // adjust layout item size to fit new width
        itemSize = CGSize(width: (view.bounds.width - 10)/2, height: (view.bounds.width / 2))
    }
    
    //MARK: API Fetch
    func getCatList() {
        apiService.getCats(with: self.page, parameters: nil) { [weak self] fetchedCats in
            if let fetchedCats = fetchedCats as? [Cat] {
                self?.cats.append(contentsOf: fetchedCats)
                if let count = self?.cats.count {
                    let newTotal = count
                    var indexPaths = [IndexPath]()
                    for i in (newTotal - fetchedCats.count)..<newTotal {
                        indexPaths.append(IndexPath(row: i, section: 0))
                    }
                    
                    self?.collectionView.insertItems(at: indexPaths)
                }
            }
        }
    }
    
    // MARK: - Navigatio
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCatDetail" {
            let vc = segue.destination as! CatDetailViewController
            vc.cat = self.seletedCat
        }
    }
    
    //MARK: Data Source
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionCell", for: indexPath) as! CatCollectionCell
        
        let cat = self.cats[indexPath.row]
        cell.catImageView?.imageURL = URL(string: cat.url) ?? nil
        
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cats.count
    }
    
    //MARK: Delegates
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.seletedCat = self.cats[indexPath.row]
        self.performSegue(withIdentifier: "ShowCatDetail", sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.cats.count - 1  {
            self.page += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.getCatList()
            })
        }
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard (kind == UICollectionView.elementKindSectionFooter) else { return UICollectionReusableView() }
        return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingFooterView", for: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout  collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        let size = CGSize(width: (view.bounds.width - 10)/2, height: 60)
        return size
    }
}

extension CatCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.bounds.width - 10)/2, height: (view.bounds.width / 2))
    }
}

extension CatCollectionViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetch: \(indexPaths)")
    }
}

class MockVC: CatCollectionViewController {
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        super.init()
        self.apiService = apiService
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
