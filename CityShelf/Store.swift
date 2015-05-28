//
//  Store.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import MapKit

/// Models a store returned by the API.
class Store: NSObject, MKAnnotation {
    let id: Int
    let title: String
    let phone: String
    let coordinate: CLLocationCoordinate2D
    var availability: String = "" {
        willSet {
            self.availability = newValue
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
}