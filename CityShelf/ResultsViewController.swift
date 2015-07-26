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

    let api = SearchService()
    var searchBar = UITextField()

    var results = [Book]()
    var searchResults: Array<NSDictionary>!
    var searchQuery: String!
    var researchProgress: UIProgressView!

    private let reuseIdentifier = "ResultCell"

    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        super.viewDidLoad()
        showResults()
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
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            // Sets gutters around cell content.
            collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)

            return CGSize(width: 93, height: 220)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CoverImageCell

        let book = coverForIndexPath(indexPath)

        cell.backgroundColor = UIColor.whiteColor()

        let imageLink = book.cover
        let data = NSData(contentsOfURL: imageLink)

        if data != nil {
            let image = UIImage(data: data!)
            cell.imageView?.image = image
        } else {
            let image = UIImage(named: "default_book.png")
            cell.imageView?.image = image
        }

        cell.title.text = book.title
        cell.author.text = book.author

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
                    as! ResultsHeaderView

                let headerText = "You searched for \"\(searchQuery)\".\nWhich book are you looking for?"
                let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
                let underlinedHeaderText = NSAttributedString(string: headerText, attributes: underlineAttribute)

                headerView.search.attributedText = underlinedHeaderText

                researchProgress = headerView.researchProgress
                configureSearchBar()

                return headerView
            default:
                fatalError("Unexpected element kind")
            }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToTitle" {
            var bk = segue.destinationViewController as! BookViewController

            let cell = sender as! CoverImageCell
            let indexPath = self.collectionView!.indexPathForCell(cell)!

            let book = results[indexPath.item]

            bk.selectedTitle = book.title
            bk.selectedAuthor = book.author
            bk.selectedCover = book.cover
            bk.selectedISBN = book.isbn
            bk.selectedAvailability = book.availability as! Array<NSDictionary>
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

        for (result: NSDictionary) in searchResults {
            let isbn = result.allKeys[0] as! String
            let first = result[isbn] as! NSArray

            let book = Book(
                isbn: isbn,
                title: first[0]["title"] as! String,
                author: first[0]["author"] as! String,
                cover: NSURL(string: first[0]["img"] as! String)!,
                availability: result[isbn] as! NSArray
            )

            self.results.append(book)
        }

        collectionView?.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    /**
        Updates search results when we search again.
    */
    func updateSearchResults() {
        searchResults = api.searchResults as! Array<NSDictionary>
        showResults()
    }

    /**
        Styles and sets up the search bar.
        @todo Pull this out, since it's shared with BookViewController. (EW 24 Apr 2015)
    */
    func configureSearchBar() {
        let cityShelfGreen = Settings().cityShelfGreen

        searchBar.frame = CGRectMake(0, 0, 250, 20)

        searchBar.textColor = cityShelfGreen
        searchBar.attributedPlaceholder = NSAttributedString(string: "Search again",
            attributes:[NSForegroundColorAttributeName: cityShelfGreen])

        searchBar.font = UIFont(name: "CooperHewitt-Bold", size: 16)

        var space = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))

        searchBar.leftViewMode = UITextFieldViewMode.Always
        searchBar.leftView = space

        searchBar.delegate = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)

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
        api.search(api.formatQuery(searchQuery), searchProgress: researchProgress, callback: updateSearchResults)

        return true
    }
}