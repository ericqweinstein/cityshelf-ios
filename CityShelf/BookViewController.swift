//
//  BookViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var author: UILabel!

    var selectedTitle: String!
    var selectedAuthor: String!

    override func viewDidLoad() {
        bookTitle.text = selectedTitle
        author.text = selectedAuthor
    }
}