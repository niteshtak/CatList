//
//  Cat.swift
//  GiniKit
//
//  Created by Nitesh Tak on 24/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import Foundation

public struct Cat: Codable {
    
    public var id: String
    public var url: String
    public var width: Int
    public var height: Int
    
}

public struct Cats: Decodable {
    public let cats: [Cat]
}
