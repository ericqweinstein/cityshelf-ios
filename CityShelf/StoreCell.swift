//
//  StoreCell.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// Manages individual stores in the StoresView.
class StoreCell: UITableViewCell {
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storePrice: UILabel!
    @IBOutlet weak var storeAvailability: UILabel!
}