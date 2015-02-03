//
//  Store.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import Foundation

/// Models a store that CityShelf can search.
class Store {
    var id: Int
    var name: String
    var phone: String
    var url: NSURL
    var map: [String: String]
    
    /**
        Creates a new store instance.

        :param: id The store's ID number.
        :param: name The name of the store.
        :param: phone The store's phone number.
        :param: url The store website's URL.
        :param: map A dictionary representing the store's physical location.

        :returns: A new store instance.
    */
    init(id: Int, name: String, phone: String, url: NSURL, map: [String: String]) {
        self.id = id
        self.name = name
        self.phone = phone
        self.url = url
        self.map = map
    }
}