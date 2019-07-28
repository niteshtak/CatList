//
//  GiniBaseUITests.swift
//  CatListUITests
//
//  Created by Nitesh Tak on 29/7/19.
//  Copyright © 2019 Gini. All rights reserved.
//

import XCTest

class GiniBaseUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        app.launchArguments += ["UI-TESTING"]
        app.launchEnvironment["AllCats"] = jsonString(for: "SampleCats")
    }
    
    func jsonString(for fileName: String) -> String? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else { return nil }
        return try? String(contentsOf: url, encoding: .utf8)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    private func waiterResult(for predicate:NSPredicate, element: XCUIElement, timeout: TimeInterval = 60) -> Bool {
        let expectation = XCTNSPredicateExpectation(predicate: predicate,
                                                    object: element)
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    func wait(for element: XCUIElement, withTimeout timeout: TimeInterval = 60) -> Bool {
        return waiterResult(for: NSPredicate(format: "exists == true"), element: element, timeout: timeout)
    }
    
    func waitForEnabled(for element: XCUIElement, withTimeout timeout: TimeInterval = 60) -> Bool {
        return waiterResult(for: NSPredicate(format: "isEnabled == true"), element: element, timeout: timeout)
    }
    
    func tap(_ element: XCUIElement, withTitle title:String, withTimeout timeout: TimeInterval = 60) {
        XCTAssert(wait(for: element, withTimeout:timeout), "Error:Unable to tap element \(title)")
        
        element.forceTapElement()
    }
    
    func tapIfExists(element: XCUIElement) {
        if wait(for: element, withTimeout: 10) {
            element.tap()
        }
    }
    
    func testExample() {
        
    }
}


extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0))
            coordinate.tap()
        }
    }
}
