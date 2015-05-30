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

        var latitude = NSUserDefaults.standardUserDefaults().doubleForKey("Latitude")
        var longitude = NSUserDefaults.standardUserDefaults().doubleForKey("Longitude")

        var completeness = Float(0.30)
        searchProgress.setProgress(completeness, animated: true)

        dispatch_group_enter(group)
        request("\(searchEndpoint)/books/?query=\(queryString)&latitude=\(latitude)&longitude=\(longitude)") {
            (response) in

            let results = response as NSArray
            let hits = results[0] as Dictionary<String, NSArray>

            for (isbn, availability) in hits {
                let hit = [isbn: availability] as Dictionary
                books.addObject(hit)
                completeness += 0.70 / Float(hits.count)
            }

            dispatch_group_leave(group)

            dispatch_async(dispatch_get_main_queue()) {
                searchProgress.setProgress(completeness, animated: true)
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
    func stores(callback: (NSMutableArray) -> ()) {
        var returnedStores = NSMutableArray()
        let group = dispatch_group_create()

        var latitude = NSUserDefaults.standardUserDefaults().doubleForKey("Latitude")
        var longitude = NSUserDefaults.standardUserDefaults().doubleForKey("Longitude")

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