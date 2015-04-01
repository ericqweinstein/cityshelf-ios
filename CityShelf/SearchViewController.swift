//
//  SearchViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// View controller for the book search field.
class SearchViewController: UIViewController, UITextFieldDelegate {
    var query = ""
    let api = SearchService()

    @IBOutlet weak var searchField: UITextField!
    
    @IBAction func searchButtonClicked(sender: AnyObject) {
        query = searchField.text
        api.searchResults = search(formatQuery(query))

        performSegueWithIdentifier("goToResults", sender: nil)
    }

    /**
        Allows us to pass API data to the ResultsViewController.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToResults" {
            var svc = segue.destinationViewController as ResultsViewController

            svc.searchResults = api.searchResults
            svc.searchQuery = query
        }
    }
    
    /**
        Styles the search bar.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var border = CALayer()
        var width  = CGFloat(3.0)
        
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0,
            y: searchField.frame.size.height - width,
            width: searchField.frame.size.width,
            height: searchField.frame.size.height)
        
        border.borderWidth = width
        searchField.layer.addSublayer(border)
        searchField.layer.masksToBounds = true
        searchField.layer.cornerRadius = 0.0
        
        searchField.attributedPlaceholder = NSAttributedString(string: "Title, author, ISBN",
            attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
        
        searchField.delegate = self
    }
    
    /**
        Sets the search text if the return key is
        pressed rather than the search button.
    
        :param: textField The search text field.
        :returns: Boolean true.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        query = searchField.text
        api.searchResults = search(formatQuery(query))

        performSegueWithIdentifier("goToResults", sender: nil)

        return true
    }

    /**
        Formats the URL query string.

        :param: queryString The query.
        :returns: The formatted query string.
    */
    func formatQuery(queryString: String) -> String {
        return queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!
    }

    /**
        Searches the API for a particular title/author.
    
        :param: queryString The query.
        :returns: An array of search results.
    */
    func search(queryString: String) -> NSArray {
        let endpoint = api.settings.searchEndpoint
        let numberOfStores = api.settings.numberOfStores
        
        let group = dispatch_group_create()
        var searchResults = NSMutableArray()

        for storeNumber in (0..<numberOfStores) {
            dispatch_group_enter(group)

            api.request("\(endpoint)/\(storeNumber)/?query=\(queryString)") {
                (response) in
                searchResults.addObjectsFromArray(response)
                dispatch_group_leave(group)
            }
        }

        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

        return searchResults as NSArray
    }
}