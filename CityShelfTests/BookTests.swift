//
//  BookTests.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import XCTest

class BookTests: XCTestCase {
    var book: Book?

    override func setUp() {
        super.setUp()

        let url = NSURL(string: "www.example.com")
        let availability: NSDictionary = ["store": "0",
                                          "availability": "true",
                                          "price": "9.99"]

        book = Book(
            isbn: "9780123456789",
            title: "Cat's Cradle",
            author: "Kurt Vonnegut",
            cover: url!,
            availability: [availability]
        )
    }

    func testISBN() {
        XCTAssertEqual(book!.isbn, "9780123456789", "Book has an ISBN.")
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
}