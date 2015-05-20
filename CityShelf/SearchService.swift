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
    let searchEndpoint = "http://www.cityshelf.com"
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

    /**
        Formats the search query string.

        :param: queryString The query.
        :returns: The formatted query string.
    */
    func formatQuery(queryString: String) -> String {
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._* ")

        return queryString.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!.stringByReplacingOccurrencesOfString(" ", withString: "+")
    }

    /**
        Searches the API for a particular title/author.

        :param: queryString The query.
        :param: searchProgress The UIProgressView to update as results are fetched.
        :param: callback The completion handler to execute when done searching.
    */
    func search(queryString: String, searchProgress: UIProgressView, callback: () -> ()) {
        var books = NSMutableArray()
        let group = dispatch_group_create()
        let city = NSUserDefaults.standardUserDefaults().valueForKey("City") as String

        // @todo Remove this as soon as we finish transitioning
        // from v1 to v2 API endpoints. (EW 19 May 2015)
        var startAndEnd: (start: Int, end: Int)

        switch city {
        case "Boston":
            startAndEnd = (start: 8, end: 11)
        case "Chicago":
            startAndEnd = (start: 12, end: 16)
        case "Minneapolis":
            startAndEnd = (start: 17, end: 20)
        case "Portland":
            startAndEnd = (start: 21, end: 23)
        case "Seattle":
            startAndEnd = (start: 24, end: 28)
        // Default to NYC
        default:
            startAndEnd = (start: 0, end: 7)
        }

        let numberOfStores = (startAndEnd.end - startAndEnd.start) + 1
        var completeness = (1 / Float(numberOfStores))
        searchProgress.setProgress(completeness, animated: true)

        for storeNumber in (startAndEnd.start...startAndEnd.end) {
            dispatch_group_enter(group)
            request("\(searchEndpoint)/api/stores/\(storeNumber)/?query=\(queryString)") {
                (response) in
                books.addObjectsFromArray(response)
                completeness += (1 / Float(numberOfStores))
                dispatch_group_leave(group)

                dispatch_async(dispatch_get_main_queue()) {
                    searchProgress.setProgress(completeness, animated: true)
                }
            }
        }

        searchResults = books

        dispatch_group_notify(group, dispatch_get_main_queue()) { callback() }
    }

    /**
        Asks the API which stores to search.
    
        :param: latitude The latitude for which we want the closest stores.
        :param: longitude The longitude for which we want the closest stores.
        :param: callback The completion handler to execute.
    */
    func stores(city: String, callback: (NSMutableArray) -> ()) {
        var returnedStores = NSMutableArray()
        let group = dispatch_group_create()

        // @todo Remove this as soon as we finish transitioning
        // from v1 to v2 API endpoints. (EW 19 May 2015)
        var latitude: String
        var longitude: String

        switch city {
        case "Boston":
            latitude = "42.3601"
            longitude = "-71.0589"
        case "Chicago":
            latitude = "41.8369"
            longitude = "-87.6847"
        case "Minneapolis":
            latitude = "44.9778"
            longitude = "-93.2650"
        case "Portland":
            latitude = "45.5200"
            longitude = "-122.6819"
        case "Seattle":
            latitude = "47.6097"
            longitude = "-122.3331"
        // Default to NYC
        default:
            latitude = "40.7127"
            longitude = "-74.0059"
        }

        dispatch_group_enter(group)
        request("\(searchEndpoint)/stores/?latitude=\(latitude)&longitude=\(longitude)") {
            (response) in
            returnedStores.addObjectsFromArray(response)

            dispatch_group_leave(group)
            dispatch_async(dispatch_get_main_queue()) {
                callback(returnedStores)
            }
        }
    }
}