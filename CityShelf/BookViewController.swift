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
class BookViewController: UIViewController {
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var isbn: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var storesList: UITableView!

    var selectedTitle: String!
    var selectedAuthor: String!
    var selectedCover: NSURL!
    var selectedISBN: String!
    var selectedAvailability: Array<Book>!

    let initialLocation = CLLocation(latitude: 40.759710, longitude: -73.974262)
    let regionRadius: CLLocationDistance = 8000

    // @todo Remove this and replace with API call. (EW 13 Apr 2015)
    let stores = [
        Store(
            title: "Astoria Bookshop",
            phone: "tel:+1-718-278-2665",
            coordinate: CLLocationCoordinate2D(latitude: 40.763754, longitude: -73.923849)
        ),
        Store(
            title: "Bank Street Books",
            phone: "tel:+1-212-678-1654",
            coordinate: CLLocationCoordinate2D(latitude: 40.805786, longitude: -73.966143)
        ),
        Store(
            title: "Book Culture",
            phone: "tel:+1-212-865-1588",
            coordinate: CLLocationCoordinate2D(latitude: 40.805135, longitude: -73.964991)
        ),
        Store(
            title: "Greenlight Bookstore",
            phone: "tel:+1-718-246-0200",
            coordinate: CLLocationCoordinate2D(latitude: 40.686502, longitude: -73.974571)
        ),
        Store(
            title: "McNally Jackson",
            phone: "tel:+1-212-274-1160",
            coordinate: CLLocationCoordinate2D(latitude: 40.723518, longitude: -73.996061)
        ),
        Store(
            title: "St. Mark's Bookshop",
            phone: "tel:+1-212-260-7853",
            coordinate: CLLocationCoordinate2D(latitude: 40.729921, longitude: -73.989448)
        ),
        Store(
            title: "Word Bookstore",
            phone: "tel:+1-718-383-0096",
            coordinate: CLLocationCoordinate2D(latitude: 40.729197, longitude: -73.957319)
        )
    ]

    override func viewDidLoad() {
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
        Sets up the title image and metadata.
    */
    func configureBook() {
        bookTitle.text = selectedTitle
        author.text = selectedAuthor
        isbn.text = selectedISBN

        let coverData = NSData(contentsOfURL: selectedCover)
        cover.image = UIImage(data: coverData!)
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
        storesList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "storeCell")
    }
}