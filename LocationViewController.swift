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

        switch selectedCity {
        case "Boston":
            latitude = 42.3601
            longitude = -71.0589
        case "Chicago":
            latitude = 41.8369
            longitude = -87.6847
        case "Minneapolis":
            latitude = 44.9778
            longitude = -93.2650
        case "Portland":
            latitude = 45.5200
            longitude = -122.6819
        case "Seattle":
            latitude = 47.6097
            longitude = -122.3331
        // Default to NYC
        default:
            latitude = 40.7127
            longitude = -74.0059
        }

        NSUserDefaults.standardUserDefaults().setValue(selectedCity, forKey: "City")
        NSUserDefaults.standardUserDefaults().setDouble(latitude, forKey: "Latitude")
        NSUserDefaults.standardUserDefaults().setDouble(longitude, forKey: "Longitude")

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