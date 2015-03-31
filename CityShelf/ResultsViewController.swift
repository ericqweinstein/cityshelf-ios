//
//  ResultsViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// View controller for API search results.
class ResultsViewController: UICollectionViewController {
    var results  = [Book]()

    var toPass: NSArray!

    private let reuseIdentifier = "CityShelfCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CityShelf"
        showResults()
    }

    /**
        Overrides the number of sections in the collection
        in order to show one section per search result.
    */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell

        // Style the cell.
        cell.backgroundColor = UIColor.whiteColor()

        return cell
    }

    func showResults() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        for result in toPass {
            let title  = result["title"] as String
            let author = result["author"] as String
            let price  = result["price"] as String
            let store  = result["storeLink"] as String
            let avail  = result["availability"] as String
            let phone  = result["phone"] as String
            let img    = result["img"] as String

            let book = Book(title: title,
                author: author,
                cover: NSURL(string: img)!,
                availability: avail,
                link: NSURL(string: store)!,
                price: (price as NSString).doubleValue)

            self.results.append(book)

            // Debugging.
            println("\(title) \(author) at \(price) (call: \(phone))")

            self.collectionView?.reloadData()
        }

        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}