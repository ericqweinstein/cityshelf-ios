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
    @IBOutlet weak var map: MKMapView!

    var selectedTitle: String!
    var selectedAuthor: String!
    var selectedCover: NSURL!

    let initialLocation = CLLocation(latitude: 40.738640, longitude: -73.932250)
    let regionRadius: CLLocationDistance = 5000

    override func viewDidLoad() {
        bookTitle.text = selectedTitle
        author.text = selectedAuthor

        let coverData = NSData(contentsOfURL: selectedCover)
        cover.image = UIImage(data: coverData!)

        centerMapOnLocation(initialLocation)

        map.delegate = self

        // Test dropping a pin on the map. (EW 12 Apr 2015)
        let store = Store(
            title: "WORD Bookstore",
            coordinate: CLLocationCoordinate2D(latitude: 40.729197, longitude: -73.957319)
        )

        map.addAnnotation(store)
    }

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0,
            regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
    }
}