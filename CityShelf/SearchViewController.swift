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

    @IBAction func changeCity(sender: AnyObject) {
        performSegueWithIdentifier("backToLocation", sender: nil)
    }

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchProgress: UIProgressView!

    @IBAction func searchButtonClicked(sender: AnyObject) {
        query = searchField.text
        api.search(api.formatQuery(query), searchProgress: searchProgress, goToResults)
    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        super.viewWillAppear(animated)
    }


    override func viewWillDisappear(animated: Bool) {
        if (navigationController?.topViewController != self) {
            navigationController?.navigationBarHidden = false
        }
        super.viewWillDisappear(animated)
    }

    /**
        Allows us to pass API data to the ResultsViewController.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToResults" {
            var svc = segue.destinationViewController as ResultsViewController

            svc.searchResults = api.searchResults as Array<NSDictionary>
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

        searchField.attributedPlaceholder = NSAttributedString(string: "Title, author, or ISBN",
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
        api.search(api.formatQuery(query), searchProgress: searchProgress, goToResults)

        return true
    }

    /**
        Segues to the search results view.
    */
    func goToResults() {
        performSegueWithIdentifier("goToResults", sender: nil)
    }
}