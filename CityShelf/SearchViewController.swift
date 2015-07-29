//
//  SearchViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit
import CoreLocation

/// View controller for the book search field.
class SearchViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    var query = ""
    let api = SearchService()

    @IBAction func changeCity(sender: AnyObject) {
        let locationManager = CLLocationManager()
        locationManager.delegate = self

        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
            handleLocationServices()
        } else {
            performSegueWithIdentifier("backToLocation", sender: nil)
        }
    }

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchProgress: UIProgressView!

    @IBAction func searchButtonClicked(sender: AnyObject) {
        query = searchField.text
        api.search(api.formatQuery(query), searchProgress: searchProgress, callback: goToResults)
    }

    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
        navigationController?.navigationBarHidden = true
        super.viewWillAppear(animated)
    }


    override func viewWillDisappear(animated: Bool) {
        if (navigationController?.topViewController != self) {
            navigationController?.navigationBarHidden = false
        }

        searchProgress.setProgress(0, animated: true)

        super.viewWillDisappear(animated)
    }

    /**
        Allows us to pass API data to the ResultsViewController.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToResults" {
            var svc = segue.destinationViewController as! ResultsViewController

            svc.searchResults = api.searchResults as! Array<NSDictionary>
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
        api.search(api.formatQuery(query), searchProgress: searchProgress, callback: goToResults)

        return true
    }

    /**
        Segues to the search results view.
    */
    func goToResults() {
        performSegueWithIdentifier("goToResults", sender: self)
    }

    /**
        If the user is already using location services, let them know
        they need to disable in order to pick their city.
    */
    func handleLocationServices() {
        let alertController = UIAlertController(
            title: "Location Services Enabled",
            message: "You cannot pick your city while location services are enabled. You can disable location services under Settings > CityShelf.",
            preferredStyle: .Alert
        )

        let settingsAction = UIAlertAction(
            title: "Go to Settings",
            style: .Default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)

                if let url = settingsUrl {
                    UIApplication.sharedApplication().openURL(url)
                }
        }

        let cancelAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)

        presentViewController(alertController, animated: true, completion: nil)
    }
}