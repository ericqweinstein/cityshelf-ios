//
//  BookViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// View controller for API search results.
class BookViewController: UITableViewController {
    var results  = [Book]()
    var settings = Settings()
    
    let pendingOperations = PendingOperations()
    
    // var service: BookService!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CityShelf"
        fetchTitleDetails()
    }

    /**
        @todo Document. (EW 14 Mar 2015)
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /**
        @todo Document. (EW 14 Mar 2015)
    */
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    /**
        @todo Document. (EW 14 Mar 2015)
    */
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    /**
        @todo Document. (EW 14 Mar 2015)
    */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier", forIndexPath: indexPath) as UITableViewCell
        
        if cell.accessoryView == nil {
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            cell.accessoryView = indicator
        }
        
        let indicator = cell.accessoryView as UIActivityIndicatorView
        
        let bookDetails = results[indexPath.row]
        
        cell.textLabel?.text = bookDetails.title
        
        let imageLink = bookDetails.cover
        let data = NSData(contentsOfURL: imageLink)
        
        if data != nil {
            let image = UIImage(data: data!)
            cell.imageView?.image = image
        }
        
        switch (bookDetails.state) {
        case .Failed:
            indicator.stopAnimating()
            // cell.textLabel?.text = "Failed to load"
        case .New:
            indicator.startAnimating()
            self.startOperationsForBook(bookDetails, indexPath:indexPath)
        case .Downloaded:
            NSLog("Downloaded image successfully.")
        }
        
        return cell
    }
    
    /**
        @todo Document. (EW 14 Mar 2015)
    */
    func startOperationsForBook(bookDetails: Book, indexPath: NSIndexPath){
        switch (bookDetails.state) {
        case .New:
            startDownloadForRecord(bookDetails, indexPath: indexPath)
        default:
            NSLog("Nothing to do here!")
        }
    }
    
    /**
        @todo Document. (EW 14 Mar 2015)
    */
    func startDownloadForRecord(bookDetails: Book, indexPath: NSIndexPath) {
        if let downloadOperation = pendingOperations.downloadsInProgress[indexPath] {
            return
        }
        
        let downloader = ImageDownloader(book: bookDetails)

        downloader.completionBlock = {
            if downloader.cancelled {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
        }

        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    /**
        @todo Document this. (EW 14 Mar 2015)
    */
    func fetchTitleDetails() {
        let request = NSURLRequest(URL: NSURL(string: settings.searchEndpoint)!)
        var parseError: NSError?
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            if data != nil {
                let searchResults = NSJSONSerialization.JSONObjectWithData(data,
                    options: NSJSONReadingOptions.MutableContainers, error: &parseError) as NSArray
                
                for result in searchResults {
                    let title  = result["title"] as String
                    let author = result["author"] as String
                    let price  = result["price"] as String
                    let store  = result["storeLink"] as String
                    let avail  = result["availability"] as String
                    let phone  = result["phone"] as String
                    let img    = result["img"] as String
                    
                    let book = Book(title: title,
                        author: author,
                        cover: NSURL(string: img)!,
                        availability: avail,
                        link: NSURL(string: store)!,
                        price: (price as NSString).doubleValue)
                    
                    self.results.append(book)
                    // println("\(title) \(author) at \(price) (call: \(phone))")
                    self.tableView.reloadData()
                }
            }
            
            if error != nil {
                let alert = UIAlertView(title: "We're Sorry",
                    message: error.localizedDescription,
                    delegate: nil,
                    cancelButtonTitle: "OK")
                
                alert.show()
            }
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}