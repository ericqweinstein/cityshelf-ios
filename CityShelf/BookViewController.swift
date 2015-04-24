//
//  BookViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit
import MapKit

/// Detail view for an individual book.
class BookViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var isbn: UILabel!

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var researchProgress: UIProgressView!

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var storesList: UITableView!

    var selectedTitle: String!
    var selectedAuthor: String!
    var selectedCover: NSURL!
    var selectedISBN: String!
    var selectedAvailability: Array<Book>!

    let initialLocation = CLLocation(latitude: 40.759710, longitude: -73.974262)
    let regionRadius: CLLocationDistance = 8000

    let api = SearchService()
    var query = ""

    /**
        Only allow portrait orientation for this view.
    */
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }

    // @todo Remove this and replace with API call. (EW 13 Apr 2015)
    let stores = [
        Store(
            title: "Astoria Bookshop",
            phone: "tel:7182782665",
            coordinate: CLLocationCoordinate2D(latitude: 40.763754, longitude: -73.923849)
        ),
        Store(
            title: "Bank Street Books",
            phone: "tel:2126781654",
            coordinate: CLLocationCoordinate2D(latitude: 40.805786, longitude: -73.966143)
        ),
        Store(
            title: "Book Culture",
            phone: "tel:2128651588",
            coordinate: CLLocationCoordinate2D(latitude: 40.805135, longitude: -73.964991)
        ),
        Store(
            title: "Greenlight Bookstore",
            phone: "tel:7182460200",
            coordinate: CLLocationCoordinate2D(latitude: 40.686502, longitude: -73.974571)
        ),
        Store(
            title: "McNally Jackson",
            phone: "tel:2122741160",
            coordinate: CLLocationCoordinate2D(latitude: 40.723518, longitude: -73.996061)
        ),
        Store(
            title: "St. Mark's Bookshop",
            phone: "tel:2122607853",
            coordinate: CLLocationCoordinate2D(latitude: 40.729921, longitude: -73.989448)
        ),
        Store(
            title: "Word Bookstore",
            phone: "tel:7183830096",
            coordinate: CLLocationCoordinate2D(latitude: 40.729197, longitude: -73.957319)
        )
    ]

    override func viewDidLoad() {
        configureSearchBar()
        configureBook()
        configureMap()
        configureStoreList()
    }

    /**
        Centers the map on the desired location.

        :param: location The desired location.
    */
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0,
            regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }

    /**
        Styles and sets up the search bar.
    */
    func configureSearchBar() {
        let cityShelfGreen = UIColor(red: 0, green: 250/255, blue: 159/255, alpha: 1)

        searchBar.attributedPlaceholder = NSAttributedString(string: "Search again",
            attributes:[NSForegroundColorAttributeName: cityShelfGreen])

        var space = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))

        searchBar.leftViewMode = UITextFieldViewMode.Always
        searchBar.leftView = space

        searchBar.delegate = self

        researchProgress.setProgress(0, animated: true)
    }

    /**
        Sets up the title image and metadata.
    */
    func configureBook() {
        bookTitle.text = selectedTitle
        author.text = selectedAuthor
        isbn.text = selectedISBN

        if let coverData = NSData(contentsOfURL: selectedCover) {
            cover.image = UIImage(data: coverData)
        }
    }

    /**
        Sets up the map subview.
    */
    func configureMap() {
        centerMapOnLocation(initialLocation)
        map.delegate = self
        map.addAnnotations(stores)
    }

    /**
        Sets up the store list subview.
    */
    func configureStoreList() {
        storesList.delegate = self
        storesList.dataSource = self
    }

    /**
        Sets the search text if the return key is
        pressed rather than the search button.

        :param: textField The search text field.
        :returns: Boolean true.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        query = searchBar.text
        api.search(api.formatQuery(query), searchProgress: researchProgress, searchAgain)

        return true
    }

    /**
        Allows us to pass API data to the ResultsViewController.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "searchAgain" {
            var svc = segue.destinationViewController as ResultsViewController

            svc.searchResults = api.searchResults
            svc.searchQuery = query
        }
    }

    /**
        Segues to the individual title view.
    */
    func searchAgain() {
        performSegueWithIdentifier("searchAgain", sender: nil)
    }
}