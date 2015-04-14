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
            availability: "On shelves now",
            link: url!,
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
        XCTAssertEqual(book!.cover.absoluteString!, "www.example.com")
    }

    func testAvailability() {
        XCTAssertEqual(book!.availability, "On shelves now")
    }

    func testPrice() {
        XCTAssertEqual(book!.price, 14.99)
    }

    func testISBN() {
        XCTAssertEqual(book!.isbn, "9780123456789")
    }
}