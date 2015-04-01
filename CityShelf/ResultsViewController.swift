//
//  ResultsViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// View controller for API search results.
class ResultsViewController: UICollectionViewController,
                             UICollectionViewDelegateFlowLayout {
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

    /**
        @todo Document this. (EW 31 Mar 2015)
    */
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            return CGSize(width: 93, height: 140)
    }

    /**
        @todo Document this. (EW 31 Mar 2015)
    */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as CoverImageCell

        let book = coverForIndexPath(indexPath)

        cell.backgroundColor = UIColor.whiteColor()

        let imageLink = book.cover
        let data = NSData(contentsOfURL: imageLink)

        if data != nil {
            let image = UIImage(data: data!)
            cell.imageView?.image = image
        }
        
        return cell
    }

    /**
        Gets the cover image for the current cell.

        :returns: The cover image.
    */
    func coverForIndexPath(indexPath: NSIndexPath) -> Book {
        return results[indexPath.row]
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