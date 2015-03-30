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
        search(formatQuery(query))
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
        search(formatQuery(query))

        return true
    }

    /**
        Formats the URL query string.

        :param: queryString The query.
        :returns: The percent-encoded query string.
    */
    func formatQuery(queryString: String) -> String {
        return queryString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!
    }

    /**
        Searches the API for a particular title/author.
    
        :param: queryString The query.
    */
    func search(queryString: String) -> Void {
        let endpoint = api.settings.searchEndpoint
        let numberOfStores = api.settings.numberOfStores
        
        let group = dispatch_group_create()

        for storeNumber in (0..<numberOfStores) {
            dispatch_group_enter(group)

            api.request("\(endpoint)/\(storeNumber)/?query=\(queryString)") {
                (response) in
                println(response)
                dispatch_group_leave(group)
            }
        }

        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    }
}