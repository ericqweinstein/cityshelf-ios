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
    var results = [Book]()
    var searchResults: NSArray!
    var searchQuery: String!

    private let reuseIdentifier = "CityShelfCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CityShelf"
        showResults()
    }

    override func viewDidAppear(animated: Bool) {
        collectionView?.reloadData()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }

    /**
        Sets the size of each cell in the collection
        view. Implemented in order to conform to the
        UICollectionViewDelegateFlowLayout protocol.

        :returns: The cell dimensions.
    */
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            // Sets gutters around cell content.
            collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)

            return CGSize(width: 93, height: 220)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as CoverImageCell

        let book = coverForIndexPath(indexPath)

        cell.backgroundColor = UIColor.whiteColor()

        let imageLink = book.cover
        let data = NSData(contentsOfURL: imageLink)

        if data != nil {
            let image = UIImage(data: data!)
            cell.imageView?.image = image
            cell.title.text = book.title
            cell.author.text = book.author
            cell.isbn.text = book.isbn
        }
        
        return cell
    }

    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "ResultsHeaderView",
                    forIndexPath: indexPath)
                    as ResultsHeaderView
                headerView.search.text = "You searched for \"\(searchQuery)\".\nIs this the book you're looking for?"
                return headerView
            default:
                assert(false, "Unexpected element kind")
            }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToTitle" {
            var bk = segue.destinationViewController as BookViewController

            let cell = sender as CoverImageCell
            let indexPath = self.collectionView!.indexPathForCell(cell)!

            let book = results[indexPath.item]

            bk.selectedTitle = book.title
            bk.selectedAuthor = book.author
            bk.selectedCover = book.cover
            bk.selectedISBN = book.isbn
            bk.selectedAvailability = results.filter() { $0.isbn == book.isbn }
        }
    }

    /**
        Gets the cover image for the current cell.

        :returns: The cover image.
    */
    func coverForIndexPath(indexPath: NSIndexPath) -> Book {
        return results[indexPath.row]
    }

    /**
        Converts JSON from the API into Book objects.
    */
    func showResults() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        for result in searchResults {
            let title  = result["title"] as String
            let author = result["author"] as String
            let price  = result["price"] as String
            let store  = result["storeName"] as String
            let avail  = result["availability"] as String
            let phone  = result["phone"] as String
            let img    = result["img"] as String
            let isbn   = result["isbn"] as String

            let book = Book(
                title: title,
                author: author,
                cover: NSURL(string: img)!,
                store: store,
                availability: avail,
                price: (price as NSString).doubleValue,
                isbn: isbn
            )

            self.results.append(book)
            self.collectionView?.reloadData()
        }

        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}