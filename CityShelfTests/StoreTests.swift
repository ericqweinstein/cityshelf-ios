//
//  StoreTests.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import Foundation
import MapKit
import XCTest

class StoreTest: XCTestCase {
    var store: Store?

    override func setUp() {
        super.setUp()

        store = Store(
            title: "Book Culture",
            coordinate: CLLocationCoordinate2D(latitude: 40.805135, longitude: -73.964991)
        )
    }

    func testTitle() {
        XCTAssertEqual(store!.title, "Book Culture", "Store has a title.")
    }

    func testLatitude() {
        XCTAssertEqual(store!.coordinate.latitude, 40.805135, "Store has a latitude.")
    }

    func testLongitude() {
        XCTAssertEqual(store!.coordinate.longitude, -73.964991, "Store has a longitude.")
    }
}