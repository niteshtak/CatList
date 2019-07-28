//
//  Favourite.swift
//  GiniKit
//
//  Created by Nitesh Tak on 28/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import Foundation

public struct Favorite: Codable {
    
    public var createdAt: String
    public var id: Int
    public var imageId: String
    public var userId: String
    public var subId: String
    public var image: CatImage
    
    enum CodingKeys: String, CodingKey {
        
        case createdAt = "created_at"
        case id
        case imageId = "image_id"
        case userId = "user_id"
        case subId = "sub_id"
        case image
    }
    
}

public struct CatImage: Codable {
    public var id: String
    public var url: String
}
