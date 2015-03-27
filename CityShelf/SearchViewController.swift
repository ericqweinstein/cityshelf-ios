//
//  SearchViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// View controller for the book search field.
class SearchViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var searchField: UITextField!
    
    /**
        Styles the search bar.
    */
    override func viewDidLoad() {
        var border = CALayer()
        var width  = CGFloat(3.0)
        
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0,
            y: searchField.frame.size.height - width,
            width: searchField.frame.size.width,
            height: searchField.frame.size.height)
        
        border.borderWidth = width
        searchField.layer.addSublayer(border)
        searchField.layer.masksToBounds = true
        searchField.layer.cornerRadius = 0.0
        
        searchField.attributedPlaceholder = NSAttributedString(string: "Title, author, ISBN",
            attributes:[NSForegroundColorAttributeName: UIColor.blackColor()])
        
        searchField.delegate = self
    }
    
    /**
        Sets the search text if the return key is
        pressed rather than the search button.
    
        :param: textField The search text field.
        :returns: Boolean true.
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println(searchField.text)
        return true
    }
}