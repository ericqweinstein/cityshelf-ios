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

class StoreTests: XCTestCase {
    var store: Store?

    override func setUp() {
        super.setUp()

        store = Store(
            id: "0",
            title: "Book Culture",
            phone: "tel:+1-212-865-1588",
            coordinate: CLLocationCoordinate2D(latitude: 40.805135, longitude: -73.964991)
        )
    }

    func testId() {
        XCTAssertEqual(store!.id, "0", "Store has an ID number.")
    }

    func testTitle() {
        XCTAssertEqual(store!.title, "Book Culture", "Store has a title.")
    }

    func testPhone() {
        XCTAssertEqual(store!.phone, "tel:+1-212-865-1588", "Store has a phone number.")
    }

    func testLatitude() {
        XCTAssertEqual(store!.coordinate.latitude, 40.805135, "Store has a latitude.")
    }

    func testLongitude() {
        XCTAssertEqual(store!.coordinate.longitude, -73.964991, "Store has a longitude.")
    }
}