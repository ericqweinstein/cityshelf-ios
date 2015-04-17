//
//  SearchService.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import Foundation
import UIKit

/// Performs searches against the CityShelf API.
class SearchService {
    let numberOfStores = 7
    let searchEndpoint = "http://192.168.2.6:8080/api/stores"
    var searchResults = NSArray()

    /// Manages getting and setting search results.
    var results: NSArray {
        get {
            return searchResults
        }

        set(newValue) {
            searchResults = newValue
        }
    }

    /**
        Makes the actual request to the API.

        :param: url The URL to which we should make the request.
        :param: callback A callback function to execute when making the request. The
                         callback takes an NSArray and returns nothing.
    */
    func request(url: String, callback: (NSArray) -> ()) {
        var nsURL = NSURL(string: url)

        let task = NSURLSession.sharedSession().dataTaskWithURL(nsURL!) { data, response, error in
            var parseError: NSError?

            if data != nil && data.length != 0 {
                var response = NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.MutableContainers,
                    error: &parseError) as NSArray

                callback(response)
            }

            if error != nil || data.length == 0 {
                let alert = UIAlertView(title: "We're Sorry",
                    message: "CityShelf is currently unavailable.",
                    delegate: nil,
                    cancelButtonTitle: "OK")

                alert.show()
            }
        }

        task.resume()
    }
}