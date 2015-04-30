//
//  TutorialItemController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// Manages the individual views within the tutorial sequence.
class TutorialItemController: UIViewController {
    @IBOutlet weak var instruction: UITextField!

    var itemIndex: Int = 0
    var instructionText: String = "" {
        didSet {
            if let instructionContent = instruction {
                instructionContent.text = instructionText
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        instruction!.text = instructionText
    }
}