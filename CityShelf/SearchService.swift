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

    /// Declares a local handle on our global settings.
    var settings: Settings!

    /// Declares an array of search results.
    var searchResults: NSArray

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
        Creates a new instance of the search service.

        :returns: A new instance of the search service.
    */
    init() {
        self.settings = Settings()
        self.searchResults = []
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

            if data != nil {
                var response = NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.MutableContainers,
                    error: &parseError) as NSArray

                callback(response)
            }

            if error != nil {
                let alert = UIAlertView(title: "We're Sorry",
                    message: error.localizedDescription,
                    delegate: nil,
                    cancelButtonTitle: "OK")

                alert.show()
            }
        }

        task.resume()
    }
}