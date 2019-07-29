//
//  CatDetailViewController.swift
//  CatList
//
//  Created by Nitesh Tak on 28/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import UIKit
import GiniKit

class CatDetailViewController: UIViewController {
    
    @IBOutlet weak var catImageView: GiniImageView!
    
    @IBOutlet weak var likeButton: GiniDesignableButton!
    @IBOutlet weak var dislikeButton: GiniDesignableButton!
    
    let apiService = APIService.shared
    
    var cat: Cat?
    var favourite: Favorite?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let cat = self.cat {
            self.catImageView.imageURL = URL(string: cat.url) ?? nil
        }
        
        if let cat = self.favourite {
            self.catImageView.imageURL = URL(string: cat.image.url) ?? nil
        }
        
        self.likeButton.addTargetClosure { [weak self] _ in
            if let id = self?.cat?.id {
                self?.apiService.addFovourite(with: ["image_id": id, "sub_id": APIRouter.userId]) { _ in
                    AppNotifier.success(message: "Added to favourite ✔︎")
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        
        self.dislikeButton.addTargetClosure { [weak self] _ in
            if let fav = self?.favourite {
                self?.apiService.deleteFovourite(with: fav.id) { _ in
                    print("Success")
                    self?.navigationController?.popViewController(animated: true)
                }
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
