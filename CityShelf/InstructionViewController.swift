//
//  InstructionViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController {
    /**
        @todo Document this. (EW 14 Mar 2015)
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        let timer = NSTimer.scheduledTimerWithTimeInterval(2.0,
            target: self,
            selector: "timeToMoveOn",
            userInfo: nil,
            repeats: false)
    }
    
    /**
        @todo Document this. (EW 14 Mar 2015)
    */
    func timeToMoveOn() {
        self.performSegueWithIdentifier("goToSearch", sender: self)
    }
}