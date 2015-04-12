//
//  BookViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// Detail view for an individual book.
class BookViewController: UIViewController {
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var cover: UIImageView!

    var selectedTitle: String!
    var selectedAuthor: String!
    var selectedCover: NSURL!

    override func viewDidLoad() {
        bookTitle.text = selectedTitle
        author.text = selectedAuthor

        let coverData = NSData(contentsOfURL: selectedCover)
        cover.image = UIImage(data: coverData!)
    }
}