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

    @IBOutlet weak var researchProgress: UIProgressView!

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var storesList: UITableView!

    var searchBar = UITextField()

    var selectedTitle: String!
    var selectedAuthor: String!
    var selectedCover: NSURL!
    var selectedISBN: String!
    var selectedAvailability: Array<NSDictionary>!

    let initialLocation: CLLocation = CLLocation(
        latitude: NSUserDefaults.standardUserDefaults().doubleForKey("Latitude"),
        longitude: NSUserDefaults.standardUserDefaults().doubleForKey("Longitude")
    )

    let regionRadius = NSUserDefaults.standardUserDefaults().doubleForKey("RegionRadius") as CLLocationDistance

    let api = SearchService()
    var query = ""

    var stores = [Store]()

    override func viewDidLoad() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent

        let doneSearching = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        doneSearching.numberOfTapsRequired = 2
        view.addGestureRecognizer(doneSearching)

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
        @todo Pull this out, since it's shared with ResultsViewController. (EW 24 Apr 2015)
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

        searchBar.returnKeyType = UIReturnKeyType.Search

        searchBar.delegate = self

        navigationItem.titleView = searchBar

        let magnifyingGlass = UIButton()
        magnifyingGlass.setBackgroundImage(UIImage(named: "search_icn_green.png"), forState: .Normal)
        magnifyingGlass.frame = CGRectMake(15, -50, 50, 50)
        magnifyingGlass.addTarget(self, action: "newSearch", forControlEvents: .TouchUpInside)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: magnifyingGlass)

        researchProgress.setProgress(0, animated: true)
    }

    /**
        Sets up the title image and metadata.
    */
    func configureBook() {
        bookTitle.text = selectedTitle
        author.text = selectedAuthor
        isbn.text = "ISBN: \(selectedISBN)"

        if let coverData = NSData(contentsOfURL: selectedCover) {
            cover.image = UIImage(data: coverData)
        } else {
            cover.image = UIImage(named: "default_book.png")
        }
    }

    /**
        Sets up the map subview.
    */
    func configureMap() {
        centerMapOnLocation(initialLocation)
        map.delegate = self

        api.stores() { (results) -> () in
            for result in results {
                let mapData = result["map"] as? Dictionary<String, AnyObject>
                let lat = mapData!["center"]!["latitude"]! as! CLLocationDegrees
                let long = mapData!["center"]!["longitude"]! as! CLLocationDegrees

                let s = Store(
                    id: result["id"] as! Int,
                    title: result["storeName"] as! String,
                    phone: result["phone"] as! String,
                    coordinate: CLLocationCoordinate2D(
                        latitude: lat,
                        longitude: long
                    )
                )

                for (hit: NSDictionary) in self.selectedAvailability {
                    if s.id == hit["store"] as! Int {
                        s.availability = hit["available"] as! Int
                        s.price = (hit["price"] as! NSString).doubleValue
                    }
                }

                self.stores.append(s)
            }
            
            self.map.addAnnotations(self.stores)
            self.stores.sort { $0.availability == $1.availability ? $0.price < $1.price : $0.availability > $1.availability }
            self.storesList.reloadData()
        }
    }

    /**
        Sets up the store list subview.
    */
    func configureStoreList() {
        storesList.delegate = self
        storesList.dataSource = self
    }

    /**
        Works as advertised.
    */
    func newSearch() {
        query = searchBar.text
        api.search(api.formatQuery(query), searchProgress: researchProgress, callback: searchAgain)
    }

    /**
        Sets the search text if the return key is
        pressed rather than the search button.

        :param: textField The search text field.
        :returns: Boolean true.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        newSearch()

        return true
    }

    /**
        Allows us to pass API data to the ResultsViewController.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "searchAgain" {
            var svc = segue.destinationViewController as! ResultsViewController

            svc.searchResults = api.searchResults as! Array<NSDictionary>
            svc.searchQuery = query
        }
    }

    /**
        Segues to the individual title view.
    */
    func searchAgain() {
        performSegueWithIdentifier("searchAgain", sender: nil)
    }

    /**
        Dismisses the keyboard if the user is done typing but does not want to search.
    */
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}