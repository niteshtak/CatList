//
//  CatListUITests.swift
//  CatListUITests
//
//  Created by Nitesh Tak on 23/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import XCTest

class CatListUITests: GiniBaseUITests {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAddingFavouroteCat() {
        
        app.collectionViews.children(matching: .cell).element(boundBy: 4).children(matching: .other).element.children(matching: .other).element.tap()
        app.buttons["likeIcon"].tap()
        
    }
    
    func testDeletingFavouroteCat() {

        let app = XCUIApplication()
        app.navigationBars["Cat list"].children(matching: .button).element.tap()
        app.collectionViews.children(matching: .cell).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.tap()
        app.buttons["dislikeIcon"].tap()
        
    }

}
