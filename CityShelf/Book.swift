//
//  Book.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import Foundation
import UIKit

/**
    States a book download might be in.

    - New: We haven't yet downloaded the book.
    - Downloaded: We've successfully downloaded the book.
    - Failed: We failed to download the book.
*/
enum BookState {
    case New, Downloaded, Failed
}

/// Models a book returned by the BookService.
class Book {
    var title: String
    var author: String
    var cover: NSURL
    var availability: String // To do: Make this an enum or boolean (EW 17 Feb 2015)
    var link: NSURL
    var price: Double
    var state: BookState
    var image = UIImage(named: "Placeholder")
    
    /**
        Creates a new book with the above attributes (author, title, &c).

        :param: title The book's title.
        :param: author The book's author.
        :param: cover A link to the book's cover image.
        :param: availability Indicates whether the book is available.
        :param: link A link to the book on the associated store's website.
        :param: price The price of the book.
    
        :returns: A new book instance.
    */
    init(title: String, author: String, cover: NSURL, availability: String, link: NSURL, price: Double) {
        self.title = title
        self.author = author
        self.cover = cover
        self.availability = availability
        self.link = link
        self.price = price
        self.state = BookState.New
    }
}