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
    @IBOutlet weak var instruction: UITextView!
    @IBOutlet weak var tutorialImage: UIImageView!
    @IBOutlet weak var distanceToTop: NSLayoutConstraint!

    @IBAction func gotIt(sender: UIButton) {
        performSegueWithIdentifier("goToLocation", sender: self)
    }

    var offset: CGFloat = 20

    var itemIndex: Int = 0

    var instructionText: String = "" {
        didSet {
            if let instructionContent = instruction {
                instructionContent.text = instructionText
            }

        }
    }

    var tutorialImageText: String = "" {
        didSet {
            if let tutorialImageContent = tutorialImage {
                tutorialImageContent.image = UIImage(named: tutorialImageText)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        instruction!.text = instructionText
        tutorialImage!.image = UIImage(named: tutorialImageText)

        tutorialImage.contentMode = UIViewContentMode.ScaleAspectFit
    }

    override func viewWillLayoutSubviews() {
        if topLayoutGuide.length == 0 {
            distanceToTop.constant = offset
        } else {
            distanceToTop.constant = 0
        }
    }
}