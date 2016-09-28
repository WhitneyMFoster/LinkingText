//
//  LinkingTextViewTest.swift
//  TextViewLinks
//
//  Created by Whitney Foster on 9/28/16.
//  Copyright © 2016 whitney.io. All rights reserved.
//

import XCTest

class LinkingTextViewTest: XCTestCase {
    var textView: LinkingTextView = LinkingTextView()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        print("done")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let string = LinkingTextView(string: "[Test: 123]")
        LinkingTextView(string: "This [link: https://github.com/WhitneyMFoster/LinkingText] calls the delegate and [this one] does nothing", attributes: [NSForegroundColorAttributeName: UIColor.black], linkAttributes: [NSForegroundColorAttributeName: UIColor.blue, NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName: UIColor.green])
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
