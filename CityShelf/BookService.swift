//
//  BookService.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import Foundation

/// Performs searches against the CityShelf API.
class BookService {
    
    var settings: Settings!
    
    /**
        Creates a new instance of the book service.

        :returns: A new instance of the book service.
    */
    init() {
        self.settings = Settings()
    }
    
    /**
        Searches the API for a particular title.

        :param: callback A callback function to execute when searching. The callback
                         takes an NSArray and returns nothing.
    */
    func search(callback: (NSArray) -> ()) {
        request(settings.searchEndpoint, callback: callback)
    }
    
    /**
        Makes the actual request to the API.

        :param: url The URL to which we should make the request.
        :param: callback A callback function to execute when making the request. The
                         callback takes an NSArray and returns nothing.
    */
    func request(url: String, callback: (NSArray) -> ()) {
        var nsURL = NSURL(string: url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(nsURL!) {
            (data, response, error) in
            var error: NSError?
            var response = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSArray
            
            callback(response)
        }
        
        task.resume()
    }
}