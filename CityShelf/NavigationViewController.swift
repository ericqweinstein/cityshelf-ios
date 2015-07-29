//
//  NavigationViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// Manages the NavigationViewController for searching.
class NavigationViewController: UINavigationController, UISearchBarDelegate {
    // I don't really like this, but apparently setting a high
    // negative offset is a common solution to removing the text
    // on a navigation controller's back button. (EW 28 May 2015)
    override func viewWillAppear(animated: Bool) {
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-100, 0), forBarMetrics: .Default)
    }

    /**
        Only allow portrait orientation.
    */
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
}