//
//  CoverImageCell.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// Manages individual titles in the title grid view.
class CoverImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        userInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
    }

    func handleTap(gesture: UITapGestureRecognizer) {
        println("\(title.text!) \(author.text!)")
    }
}