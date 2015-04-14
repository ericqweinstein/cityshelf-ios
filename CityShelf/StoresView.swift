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

        cell.textLabel?.text = stores[indexPath.row].title
        cell.textLabel?.font = UIFont(name: "CooperHewitt-Book", size: 14)

        return cell
    }

    /**
        @todo Remove (testing)
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
}