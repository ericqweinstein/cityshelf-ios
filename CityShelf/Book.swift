//
//  Book.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import Foundation
import UIKit

/// Models a book returned by the API.
class Book: NSObject {
    var title: String
    var author: String
    var cover: NSURL
    var store: String
    var availability: String
    var price: Double
    var image = UIImage(named: "Placeholder")
    var isbn: String

    override var description: String {
        return "\(title) \(author) (\(isbn))"
    }

    /**
        Creates a new book with the above attributes (author, title, &c).

        :param: title The book's title.
        :param: author The book's author.
        :param: cover A link to the book's cover image.
        :param: store The store associated with the book.
        :param: availability Indicates whether the book is available.
        :param: price The price of the book.
        :param: isbn The book's International Standard Book Number. The ISBN
                     serves as a unique identifier for the book.

        :returns: A new book instance.
    */
    init(title: String, author: String, cover: NSURL, store: String, availability: String, price: Double, isbn: String) {
        self.title = title
        self.author = author
        self.cover = cover
        self.store = store
        self.availability = availability
        self.price = price
        self.isbn = isbn
    }
}