//
//  LocationViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit
import CoreLocation

/// View controller for city selection and geolocation.
class LocationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var citySelection: UIPickerView!
    @IBAction func cityPicked(sender: AnyObject) {
        let selectedCity = cities[citySelection.selectedRowInComponent(0)]
        var latitude: Double
        var longitude: Double
        var regionRadius: Int

        switch selectedCity {
        case "Boston":
            latitude = 42.3601
            longitude = -71.0589
            regionRadius = 8000
        case "Chicago":
            latitude = 41.8369
            longitude = -87.6847
            regionRadius = 18000
        case "Minneapolis":
            latitude = 44.9778
            longitude = -93.2650
            regionRadius = 18000
        case "Portland":
            latitude = 45.5200
            longitude = -122.6819
            regionRadius = 8000
        case "Seattle":
            latitude = 47.5487
            longitude = -122.3331
            regionRadius = 23000
        // Default to NYC
        default:
            latitude = 40.759710
            longitude = -73.974262
            regionRadius = 8000
        }

        NSUserDefaults.standardUserDefaults().setValue(selectedCity, forKey: "City")
        NSUserDefaults.standardUserDefaults().setDouble(latitude, forKey: "Latitude")
        NSUserDefaults.standardUserDefaults().setDouble(longitude, forKey: "Longitude")
        NSUserDefaults.standardUserDefaults().setInteger(regionRadius, forKey: "RegionRadius")

        performSegueWithIdentifier("goToSearch", sender: self)
    }

    let cities = [
        "Boston",
        "Chicago",
        "Minneapolis",
        "New York City",
        "Portland",
        "Seattle"
        ]

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        citySelection.dataSource = self
        citySelection.delegate = self

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    /**
        Handles any errors that might occur while
        trying to get a fix on the user's location.
    
        :param: manager The CLLocationManager instance.
        :param: error An optional; may be an error or nil.
    */
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()

        if (error != nil) {
            let alert = UIAlertController(
                title: "Sorry! We couldn't find you.",
                message: error.description,
                preferredStyle: UIAlertControllerStyle.Alert
            )

            alert.addAction(UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil))

            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    /**
        Sets the user's location once we've got it.

        :param: manager The CLLocationManager instance.
        :param: locations The user's location.
    */
    func locationManager(manager: CLLocationManager!, didUpdateLocations location: [AnyObject]!) {
        var locationArray = location as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        var coord = locationObj.coordinate

        NSUserDefaults.standardUserDefaults().setDouble(coord.latitude, forKey: "Latitude")
        NSUserDefaults.standardUserDefaults().setDouble(coord.longitude, forKey: "Longitude")
        NSUserDefaults.standardUserDefaults().setInteger(16000, forKey: "RegionRadius")

        performSegueWithIdentifier("goToSearch", sender: self)
    }

    /**
        Starts updating the user's location if permission
        is granted.
    
        :param: manager The CLLocationManager instance.
        :param: status The authorization status.
    */
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            if (status == CLAuthorizationStatus.Authorized) {
                locationManager.startUpdatingLocation()
            } else {
                let alert = UIAlertController(
                    title: "CityShelf is not using your location.",
                    message: "You can enable geolocation in your iPhone settings.",
                    preferredStyle: UIAlertControllerStyle.Alert
                )

                alert.addAction(UIAlertAction(
                    title: "I'll pick my city",
                    style: UIAlertActionStyle.Default,
                    handler: nil))

                self.presentViewController(alert, animated: true, completion: nil)
            }
    }

    /**
        Returns the number of components in the city picker view.

        :param: pickerView The UIPickerView instance.

        :returns: The number of components (in this case, one).
    */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    /**
        Returns the number of items in the city picker view.

        :param: pickerView The UIPickerView instance.
        :param: component The number of rows per component.

        :returns: The number of items in the city picker view.
    */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }

    /**
        Returns the selected city in the UIPickerView.

        :param: pickerView The UIPickerView instance.
        :param: row The picker view row number.
        :param: component The component number.

        :returns: The selected city.
    */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return cities[row]
    }
}