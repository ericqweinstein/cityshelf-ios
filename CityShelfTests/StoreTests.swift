//
//  StoreTests.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import CityShelf
import XCTest

class StoreTests: XCTestCase {
    var store: Store?
    
    override func setUp() {
        super.setUp()
        
        let url = NSURL(string: "www.example.com")
        
        store = Store(id: 1,
                      name: "The Strand",
                      phone: "(212) 555-5555",
                      url: url!,
                      map: ["Location": "Here"])
    }
    
    func testID() {
        XCTAssertEqual(store!.id, 1, "Store has an ID.")
    }
    
    func testName() {
        XCTAssertEqual(store!.name, "The Strand", "Store has a name.")
    }
    
    func testPhone() {
        XCTAssertEqual(store!.phone, "(212) 555-5555", "Store has a phone number.")
    }
    
    func testURL() {
        XCTAssertEqual(store!.url.absoluteString!, "www.example.com", "Store has a URL.")
    }
    
    func testMap() {
        let location = store!.map["Location"]
        XCTAssertEqual(location!, "Here", "Store has a map.")
    }
}