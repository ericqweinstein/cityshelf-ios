//
//  Store.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import AddressBook
import MapKit

/// Models a store returned by the API.
class Store: NSObject, MKAnnotation {
    let id: Int
    let title: String
    let phone: String
    let coordinate: CLLocationCoordinate2D

    var availability: Int = 0 {
        willSet {
            self.availability = newValue
        }
    }

    var price: Double = 0.00 {
        willSet {
            self.price = newValue
        }
    }

    override var description: String {
        return "\(title) \(phone) (\(coordinate))"
    }

    init(id: Int, title: String, phone: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.phone = phone
        self.coordinate = coordinate

        super.init()
    }

    /**
        Creates a map item from the store instance. This allows us to open
        the Apple Maps application if a user clicks into the callout for
        the store on the map, providing directions.

        :returns: The map item.
    */
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(kABPersonAddressStreetKey): title]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)

        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}