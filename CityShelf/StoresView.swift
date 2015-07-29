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
        var cell = storesList.dequeueReusableCellWithIdentifier("StoreCell") as! StoreCell

        let storeName = stores[indexPath.row].title
        let storeID = stores[indexPath.row].id

        var price = 0.00
        var availability = 0

        for (hit: NSDictionary) in selectedAvailability {
            if storeID == hit["store"] as! Int {
                price = (hit["price"] as! NSString).doubleValue
                availability = hit["available"] as! Int
            }
        }

        annotateStoreName(availability, storeAvailabilityIcon: cell.storeAvailabilityIcon)
        cell.storeName.text = storeName
        cell.storePrice.text = normalizePrice(price)
        cell.storeAvailability.text = normalizeAvailability(availability)

        cell.storeAvailability.layer.borderWidth = 3.0
        cell.storeAvailability.layer.borderColor = Settings().cityShelfGreen.CGColor

        return cell
    }

    /**
        Calls the book store when the user selects it.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string: normalizePhone(stores[indexPath.row].phone))!)
    }

    /**
        Normalizes pricing. This is necessary because some stores
        now put "Call for price" or something to that effect rather
        than an actual dollar value.

        :param: price The price to normalize.
        :returns: The normalized price. May be a string representation
                  of a float (e.g. "$4.99") or another string (e.g.
                  "Call for price," "N/A", &c).
    */
    func normalizePrice(price: Double) -> String {
        return price > 0 ? "$" + (NSString(format: "%.2f", price) as String) : "N/A"
    }

    /**
        Normalizes phone numbers.

        :param: phoneNumber The phone number to normalize.
        :returns: The normalized phone number.
    */
    func normalizePhone(phoneNumber: String) -> String {
        return phoneNumber.stringByReplacingOccurrencesOfString("tel", withString: "telprompt")
    }

    /**
        Normalizes book availability language.

        :param: text The text to normalize.
        :returns: The normalized text.
    */
    func normalizeAvailability(text: Int) -> String {
        return text == 1 ? "Call to reserve" : "Call to place an order"
    }

    /**
        Annotates the store name to signal availability.

        :param: availability The availability of the associated title.
        :param: storeAvailabilityIcon Label indicating availability.

        :returns: The store name annotated with an "X" (unavailable) or a check
                  mark (available).
    */
    func annotateStoreName(availability: Int, storeAvailabilityIcon: UILabel!) {
        if availability == 1 {
            storeAvailabilityIcon.textColor = Settings().cityShelfGreen
        } else {
            storeAvailabilityIcon.textColor = UIColor.redColor()
        }
    }
}