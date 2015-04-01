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
    var searchResults: NSArray!
    var searchQuery: String!

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
        Sets the size of each cell in the collection
        view. Implemented in order to conform to the
        UICollectionViewDelegateFlowLayout protocol.

        :returns: The cell dimensions.
    */
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            return CGSize(width: 93, height: 200)
    }

    /**
        Overrides collectionView in order to set the
        cover image and title data for each search result.

        :returns: The collection view cell.
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
            cell.title.text = book.title
            cell.author.text = book.author
        }
        
        return cell
    }

    /**
        Overrides collectionView in order to set the header.
    */
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

    /**
        Gets the cover image for the current cell.

        :returns: The cover image.
    */
    func coverForIndexPath(indexPath: NSIndexPath) -> Book {
        return results[indexPath.row]
    }

    func showResults() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        for result in searchResults {
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
            self.collectionView?.reloadData()
        }

        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    // These may be reused to implement async image loading. (EW 31 Mar 2015)

//     let pendingOperations = PendingOperations()
//    
//     switch (bookDetails.state) {
//     case .Failed:
//        indicator.stopAnimating()
//        cell.textLabel?.text = "Failed to load"
//     case .New:
//        indicator.startAnimating()
//        self.startOperationsForBook(bookDetails, indexPath:indexPath)
//     case .Downloaded:
//        NSLog("Downloaded image successfully.")
//     }
//    
//     func startOperationsForBook(bookDetails: Book, indexPath: NSIndexPath) {
//         switch (bookDetails.state) {
//         case .New:
//             startDownloadForRecord(bookDetails, indexPath: indexPath)
//         default:
//             NSLog("Nothing to do here!")
//         }
//     }
//    
//     func startDownloadForRecord(bookDetails: Book, indexPath: NSIndexPath) {
//         if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
//             return
//         }
//    
//         let downloader = ImageDownloader(book: bookDetails)
//    
//         downloader.completionBlock = {
//             if downloader.cancelled {
//                 return
//             }
//             dispatch_async(dispatch_get_main_queue(), {
//                 self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
//                 self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//             })
//         }
//    
//         pendingOperations.downloadsInProgress[indexPath] = downloader
//         pendingOperations.downloadQueue.addOperation(downloader)
//     }
//    func fetchTitleDetails() {
//        let request = NSURLRequest(URL: NSURL(string: settings.searchEndpoint)!)
//        var parseError: NSError?
//
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
//            if data != nil {
//                let searchResults = NSJSONSerialization.JSONObjectWithData(data,
//                    options: NSJSONReadingOptions.MutableContainers, error: &parseError) as NSArray
//
//                for result in searchResults {
//                    let title  = result["title"] as String
//                    let author = result["author"] as String
//                    let price  = result["price"] as String
//                    let store  = result["storeLink"] as String
//                    let avail  = result["availability"] as String
//                    let phone  = result["phone"] as String
//                    let img    = result["img"] as String
//
//                    let book = Book(title: title,
//                        author: author,
//                        cover: NSURL(string: img)!,
//                        availability: avail,
//                        link: NSURL(string: store)!,
//                        price: (price as NSString).doubleValue)
//
//                    self.results.append(book)
//                    // println("\(title) \(author) at \(price) (call: \(phone))")
//                    self.tableView.reloadData()
//                }
//            }
//
//            if error != nil {
//                let alert = UIAlertView(title: "We're Sorry",
//                    message: error.localizedDescription,
//                    delegate: nil,
//                    cancelButtonTitle: "OK")
//
//                alert.show()
//            }
//        }
//
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//    }
}