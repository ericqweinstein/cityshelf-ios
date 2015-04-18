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
                             UICollectionViewDelegateFlowLayout,
                             UITextFieldDelegate {
    var results = [Book]()
    var api = SearchService()

    var searchResults: NSArray!
    var searchQuery: String!
    var searchBar: UITextField!
    var researchProgress: UIProgressView!

    private let reuseIdentifier = "ResultCell"

    override func viewDidLoad() {
        super.viewDidLoad()
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
                headerView.search.text = "You searched for \"\(searchQuery)\". Is this the book you're looking for?"

                searchBar = headerView.searchBar
                researchProgress = headerView.researchProgress
                configureSearchBar()

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

    // @todo Here be dragons (read: copy/paste). I'm tolerating this for the time
    // being since duplication is cheaper than the wrong abstraction, but I think
    // this should all be extracted into the SearchService() ASAP. (EW 16 Apr 2015)

    /**
        Styles and sets up the search bar.
    */
    func configureSearchBar() {
        let cityShelfGreen = UIColor(red: 0, green: 250/255, blue: 159/255, alpha: 1)

        searchBar.attributedPlaceholder = NSAttributedString(string: "Search again",
            attributes:[NSForegroundColorAttributeName: cityShelfGreen])

        var space = UIView(frame:CGRect(x:0, y:0, width:10, height:10))

        searchBar.leftViewMode = UITextFieldViewMode.Always
        searchBar.leftView = space

        searchBar.delegate = self

        researchProgress.setProgress(0, animated: true)
    }

    /**
        Sets the search text if the return key is
        pressed rather than the search button.

        :param: textField The search text field.
        :returns: Boolean true.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        searchQuery = searchBar.text
        searchResults = []
        results = []
        search(formatQuery(searchQuery))

        return true
    }

    /**
        Searches the API for a particular title/author.
        @todo Localize all this knowledge (#search, settings, &c)
        in SearchService. (EW 16 Apr 2015)

        :param: queryString The query.
    */
    func search(queryString: String) {
        let endpoint = api.searchEndpoint
        let numberOfStores = api.numberOfStores

        var completeness = (1 / Float(numberOfStores))
        researchProgress.setProgress(completeness, animated: true)

        var searchResults = NSMutableArray()

        let group = dispatch_group_create()

        for storeNumber in (0..<numberOfStores) {
            dispatch_group_enter(group)
            self.api.request("\(endpoint)/\(storeNumber)/?query=\(queryString)") {
                (response) in
                searchResults.addObjectsFromArray(response)
                completeness += (1 / Float(numberOfStores - 1))
                dispatch_group_leave(group)

                dispatch_async(dispatch_get_main_queue()) {
                    self.researchProgress.setProgress(completeness, animated: true)
                }
            }
        }

        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.searchResults = searchResults
            self.showResults()
        }
    }

    /**
        Formats the URL query string.

        :param: queryString The query.
        :returns: The formatted query string.
    */
    func formatQuery(queryString: String) -> String {
        // For some reason Heroku cares about %20 vs + for query encoding. (EW 17 Apr 2015)
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._* ")

        return queryString.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!.stringByReplacingOccurrencesOfString(" ", withString: "+")
    }
}