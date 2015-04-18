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
    @IBOutlet weak var searchProgress: UIProgressView!

    @IBAction func searchButtonClicked(sender: AnyObject) {
        query = searchField.text
        search(formatQuery(query))
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

        searchField.layer.borderColor = UIColor.whiteColor().CGColor
        searchField.layer.borderWidth = 1.0

        searchField.attributedPlaceholder = NSAttributedString(string: "Title, author, ISBN",
            attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])

        searchField.delegate = self

        searchProgress.setProgress(0, animated: true)
    }

    /**
        Sets the search text if the return key is
        pressed rather than the search button.

        :param: textField The search text field.
        :returns: Boolean true.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        query = searchField.text
        search(formatQuery(query))

        return true
    }

    /**
        Formats the URL query string.

        :param: queryString The query.
        :returns: The formatted query string.
    */
    func formatQuery(queryString: String) -> String {
        // For some reason Heroku cares about %20 vs + for query encoding. (EW 17 Apr 2015)
        let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString("-._* ")

        return queryString.stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!.stringByReplacingOccurrencesOfString(" ", withString: "+")
    }

    /**
        Searches the API for a particular title/author.
        @todo Localize all this knowledge (#search, settings, &c)
              in SearchService. (EW 16 Apr 2015)

        :param: queryString The query.
    */
    func search(queryString: String) {
        let endpoint = api.searchEndpoint
        let numberOfStores = api.numberOfStores

        var completeness = (1 / Float(numberOfStores))
        searchProgress.setProgress(completeness, animated: true)

        var searchResults = NSMutableArray()

        let group = dispatch_group_create()

        for storeNumber in (0..<numberOfStores) {
            dispatch_group_enter(group)
            self.api.request("\(endpoint)/\(storeNumber)/?query=\(queryString)") {
                (response) in
                searchResults.addObjectsFromArray(response)
                completeness += (1 / Float(numberOfStores - 1))
                dispatch_group_leave(group)

                dispatch_async(dispatch_get_main_queue()) {
                    self.searchProgress.setProgress(completeness, animated: true)
                }
            }
        }

        api.searchResults = searchResults

        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("goToResults", sender: self)
        }
    }
}