//
//  LocationViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// View controller for city selection and geolocation.
class LocationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
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
        "New York City",
        "Boston",
        "Chicago",
        "Minneapolis",
        "Portland",
        "Seattle"
        ]

    override func viewDidLoad() {
        super.viewDidLoad()
        citySelection.dataSource = self
        citySelection.delegate = self
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return cities[row]
    }
}