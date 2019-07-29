//
//  CatListTests.swift
//  CatListTests
//
//  Created by Nitesh Tak on 23/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import XCTest
import GiniKit

@testable import CatList

class CatListTests: XCTestCase {
    
    var sut: MockVC!
    var mockAPIService: MockApiService!

    override func setUp() {
        mockAPIService = MockApiService()
        sut = MockVC(apiService: mockAPIService)
    }

    override func tearDown() {
        mockAPIService = nil
        super.tearDown()
    }

    func test_fetch_cats() {
        // Given
        mockAPIService.cats = [Cat]()
    
        //When
        sut.getCatList()
        
        // Assert
        XCTAssert(mockAPIService.isFetchCatsCalled)
    }
    
    func test_all_cat_list_models() {
        // Given
        let cats = StubGenerator().stubCats()
        mockAPIService.cats = cats
        
        //When
        sut.getCatList()
        
        mockAPIService.fetchSuccess()
        
        // Number of cell view model is equal to the number of cats
        XCTAssertEqual(10, cats.count)
        
    }

}

class StubGenerator {
    func stubCats() -> [Cat] {
        let path = Bundle.main.path(forResource: "SampleCats", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        let cats = try! decoder.decode([Cat].self, from: data)
        return cats
    }
}
