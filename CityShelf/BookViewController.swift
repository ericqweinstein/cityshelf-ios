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
            coordinate: CLLocationCoordinate2D(latitude: 40.763754, longitude: -73.923849)
        ),
        Store(
            title: "Bank Street Books",
            coordinate: CLLocationCoordinate2D(latitude: 40.805786, longitude: -73.966143)
        ),
        Store(
            title: "Book Culture",
            coordinate: CLLocationCoordinate2D(latitude: 40.805135, longitude: -73.964991)
        ),
        Store(
            title: "Greenlight Bookstore",
            coordinate: CLLocationCoordinate2D(latitude: 40.686502, longitude: -73.974571)
        ),
        Store(
            title: "McNally Jackson",
            coordinate: CLLocationCoordinate2D(latitude: 40.723518, longitude: -73.996061)
        ),
        Store(
            title: "St. Mark's Bookshop",
            coordinate: CLLocationCoordinate2D(latitude: 40.729921, longitude: -73.989448)
        ),
        Store(
            title: "Word Bookstore",
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
        Adds stores as annotations to the map view.
    */
    func addStores() {
        map.addAnnotations(stores)
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

        for bk in selectedAvailability {
            println("\(bk.store): \(bk.availability)")
        }
    }

    /**
        Sets up the map subview.
    */
    func configureMap() {
        centerMapOnLocation(initialLocation)
        map.delegate = self
        addStores()
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