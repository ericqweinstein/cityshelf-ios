//
//  BookOperations.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// Manages pending asynchronous operations.
class PendingOperations {
    lazy var downloadsInProgress = [NSIndexPath: NSOperation]()
    
    lazy var downloadQueue: NSOperationQueue = {
        var queue = NSOperationQueue()
        queue.name = "Download queue"
        
        return queue
        }()
}

/// Manages image downloads for book covers.
class ImageDownloader: NSOperation {
    let book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        let imageData = NSData(contentsOfURL: self.book.cover)
        
        if self.cancelled {
            return
        }
        
        if imageData != nil && imageData!.length > 0 {
            self.book.image = UIImage(data: imageData!)!
            self.book.state = .Downloaded
        } else {
            self.book.state = .Failed
            self.book.image = UIImage(named: "Failed")
        }
    }
}