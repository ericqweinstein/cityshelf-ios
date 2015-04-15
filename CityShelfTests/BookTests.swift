//
//  BookTests.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import CityShelf
import XCTest

class BookTests: XCTestCase {
    var book: Book?

    override func setUp() {
        super.setUp()

        let url = NSURL(string: "www.example.com")

        book = Book(
            title: "Cat's Cradle",
            author: "Kurt Vonnegut",
            cover: url!,
            store: "The Strand",
            availability: "On shelves now",
            price: 14.99,
            isbn: "9780123456789"
        )
    }

    func testTitle() {
        XCTAssertEqual(book!.title, "Cat's Cradle", "Book has a title.")
    }

    func testAuthor() {
        XCTAssertEqual(book!.author, "Kurt Vonnegut", "Book has an author.")
    }

    func testCover() {
        XCTAssertEqual(book!.cover.absoluteString!, "www.example.com", "Book has a cover.")
    }

    func testStore() {
        XCTAssertEqual(book!.store, "The Strand", "Book has an associated store.")
    }

    func testAvailability() {
        XCTAssertEqual(book!.availability, "On shelves now", "Book has an availability.")
    }

    func testPrice() {
        XCTAssertEqual(book!.price, 14.99, "Book has a price.")
    }

    func testISBN() {
        XCTAssertEqual(book!.isbn, "9780123456789", "Book has an ISBN.")
    }
}