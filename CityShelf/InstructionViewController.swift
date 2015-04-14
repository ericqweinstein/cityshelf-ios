//
//  InstructionViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// View controller for displaying CityShelf instructions.
class InstructionViewController: UIViewController {
    /**
        Overrides viewDidLoad() in order to set an
        automated segue.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = NSTimer.scheduledTimerWithTimeInterval(3.0,
            target: self,
            selector: "nextView",
            userInfo: nil,
            repeats: false)
    }

    /**
        Segues to the next view.
    */
    func nextView() {
        self.performSegueWithIdentifier("goToSearch", sender: self)
    }
}