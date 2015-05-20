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

    @IBAction func gotIt(sender: AnyObject) {
        performSegueWithIdentifier("goToLocation", sender: self)
    }

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

@IBDesignable
class TutorialView: UIView {
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        CGContextSetLineWidth(context, 2.0)

        CGContextSetStrokeColorWithColor(
            context,
            UIColor.blackColor().CGColor
        )

        // Horizontal line for the ground.
        CGContextMoveToPoint(context, 25, 250)
        CGContextAddLineToPoint(context, 300, 250)

        // Rectangle for the first building.
        CGContextMoveToPoint(context, 50, 100)
        CGContextAddLineToPoint(context, 125, 100)
        CGContextAddLineToPoint(context, 125, 250)
        CGContextAddLineToPoint(context, 50, 250)
        CGContextAddLineToPoint(context, 50, 100)
        CGContextStrokePath(context)

        // Rectangle for the second building.
        CGContextMoveToPoint(context, 125, 50)
        CGContextAddLineToPoint(context, 200, 50)
        CGContextAddLineToPoint(context, 200, 250)
        CGContextAddLineToPoint(context, 125, 250)
        CGContextAddLineToPoint(context, 125, 50)
        CGContextStrokePath(context)

        // Rectangle for the third building.
        CGContextMoveToPoint(context, 200, 150)
        CGContextAddLineToPoint(context, 275, 150)
        CGContextAddLineToPoint(context, 275, 250)
        CGContextAddLineToPoint(context, 200, 250)
        CGContextAddLineToPoint(context, 200, 150)
        CGContextStrokePath(context)

        // Add in the six windows, leftmost to rightmost.

        // 1
        CGContextMoveToPoint(context, 50, 125)
        CGContextAddLineToPoint(context, 80, 125)
        CGContextAddLineToPoint(context, 80, 140)
        CGContextAddLineToPoint(context, 50, 140)
        CGContextAddLineToPoint(context, 50, 125)
        CGContextStrokePath(context)

        // 2
        CGContextMoveToPoint(context, 95, 155)
        CGContextAddLineToPoint(context, 125, 155)
        CGContextAddLineToPoint(context, 125, 170)
        CGContextAddLineToPoint(context, 95, 170)
        CGContextAddLineToPoint(context, 95, 155)
        CGContextStrokePath(context)

        // 3
        CGContextMoveToPoint(context, 125, 110)
        CGContextAddLineToPoint(context, 155, 110)
        CGContextAddLineToPoint(context, 155, 125)
        CGContextAddLineToPoint(context, 125, 125)
        CGContextAddLineToPoint(context, 125, 110)
        CGContextStrokePath(context)

        // 4
        CGContextMoveToPoint(context, 170, 85)
        CGContextAddLineToPoint(context, 200, 85)
        CGContextAddLineToPoint(context, 200, 100)
        CGContextAddLineToPoint(context, 170, 100)
        CGContextAddLineToPoint(context, 170, 85)
        CGContextStrokePath(context)

        // 5
        CGContextMoveToPoint(context, 170, 140)
        CGContextAddLineToPoint(context, 200, 140)
        CGContextAddLineToPoint(context, 200, 155)
        CGContextAddLineToPoint(context, 170, 155)
        CGContextAddLineToPoint(context, 170, 140)
        CGContextStrokePath(context)

        // 6
        CGContextMoveToPoint(context, 245, 170)
        CGContextAddLineToPoint(context, 275, 170)
        CGContextAddLineToPoint(context, 275, 185)
        CGContextAddLineToPoint(context, 245, 185)
        CGContextAddLineToPoint(context, 245, 170)
        CGContextStrokePath(context)
    }
}