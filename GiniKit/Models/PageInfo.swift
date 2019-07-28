//
//  PageInfo.swift
//  GiniKit
//
//  Created by Nitesh Tak on 24/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import Foundation

public struct pageInfo {
    
    var limit: Int = 10
    var order: String = "DESC"
    var page: Int
    
    init(page: Int) {
        self.page = page
    }
}
