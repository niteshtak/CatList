//
//  APIServiceTests.swift
//  GiniKitTests
//
//  Created by Nitesh Tak on 29/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import XCTest
import Alamofire

@testable import GiniKit

class APIServiceTests: XCTestCase {

    var sut: APIService?
    
    override func setUp() {
        super.setUp()
        sut = APIService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetch_all_cats() {
        
        // Given a apiservice
        let sut = self.sut!
        
        // When fetch all cats
        let expect = XCTestExpectation(description: "callback")
        
        sut.getCats(with: 0) { response in
            expect.fulfill()
            guard let cats = response as? [Cat] else {
                return
            }
            XCTAssert(cats.count > 0, "Cats exists")
            
            for cat in cats {
                XCTAssertNotNil(cat.id)
            }
            
        }
        wait(for: [expect], timeout: 15)
    }

}
