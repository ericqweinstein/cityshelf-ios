//
//  StoresView.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// Extends the BookViewController in order to show availability by store.
extension BookViewController: UITableViewDelegate, UITableViewDataSource {
    /**
        Sets the number of table rows.

        :returns: The number of rows.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stores.count;
    }

    /**
        Sets the text in each table row.

        :returns: The row (a UITableViewCell).
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = storesList.dequeueReusableCellWithIdentifier("storeCell") as UITableViewCell

        let storeName = stores[indexPath.row].title
        var price = 0.00
        var availability = "Call to place an order"

        // @todo This is a horrible idea; correct ASAP. (EW 14 Apr 2015)
        for bk in selectedAvailability {
            if bk.store == storeName {
                price = bk.price
                availability = bk.availability
            }
        }

        cell.textLabel?.text = "\(storeName) $\(price) \(normalizeAvailability(availability))"
        cell.textLabel?.font = UIFont(name: "CooperHewitt-Book", size: 14)

        return cell
    }

    /**
        Calls the book store when the user selects it.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string: stores[indexPath.row].phone)!)
    }

    /**
        Normalizes book availability language.

        :param: text The text to normalize.
        :returns: The normalized text.
    */
    func normalizeAvailability(text: String) -> String {
        return text == "On shelves now" ? "Call to reserve" : "Call to place an order"
    }
}