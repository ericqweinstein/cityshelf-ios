//
//  ResultsHeaderView.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// Handles the header text in the search results view.
class ResultsHeaderView: UICollectionReusableView {
    @IBOutlet weak var search: UILabel!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var researchProgress: UIProgressView!
}