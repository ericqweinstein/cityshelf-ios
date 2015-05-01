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
        CGContextSetStrokeColorWithColor(context,
            UIColor.blackColor().CGColor)

        // Horizontal line for the ground.
        CGContextMoveToPoint(context, 0, 250)
        CGContextAddLineToPoint(context, 400, 250)

        // Rectangle for the first building.
        CGContextMoveToPoint(context, 50, 100)
        CGContextAddLineToPoint(context, 150, 100)
        CGContextAddLineToPoint(context, 150, 250)
        CGContextAddLineToPoint(context, 50, 250)
        CGContextAddLineToPoint(context, 50, 100)
        CGContextStrokePath(context)

        // Rectangle for the second building.
        CGContextMoveToPoint(context, 150, 50)
        CGContextAddLineToPoint(context, 250, 50)
        CGContextAddLineToPoint(context, 250, 250)
        CGContextAddLineToPoint(context, 150, 250)
        CGContextAddLineToPoint(context, 150, 50)
        CGContextStrokePath(context)

        // Rectangle for the third building.
        CGContextMoveToPoint(context, 250, 150)
        CGContextAddLineToPoint(context, 350, 150)
        CGContextAddLineToPoint(context, 350, 250)
        CGContextAddLineToPoint(context, 250, 250)
        CGContextAddLineToPoint(context, 250, 50)
        CGContextStrokePath(context)

        // Add in the six windows, leftmost to rightmost.

        // 1
        CGContextMoveToPoint(context, 50, 125)
        CGContextAddLineToPoint(context, 100, 125)
        CGContextAddLineToPoint(context, 100, 140)
        CGContextAddLineToPoint(context, 50, 140)
        CGContextAddLineToPoint(context, 50, 125)
        CGContextStrokePath(context)

        // 2
        CGContextMoveToPoint(context, 100, 155)
        CGContextAddLineToPoint(context, 150, 155)
        CGContextAddLineToPoint(context, 150, 170)
        CGContextAddLineToPoint(context, 100, 170)
        CGContextAddLineToPoint(context, 100, 155)
        CGContextStrokePath(context)

        // 3
        CGContextMoveToPoint(context, 150, 110)
        CGContextAddLineToPoint(context, 200, 110)
        CGContextAddLineToPoint(context, 200, 125)
        CGContextAddLineToPoint(context, 150, 125)
        CGContextAddLineToPoint(context, 150, 110)
        CGContextStrokePath(context)

        // 4
        CGContextMoveToPoint(context, 200, 85)
        CGContextAddLineToPoint(context, 250, 85)
        CGContextAddLineToPoint(context, 250, 100)
        CGContextAddLineToPoint(context, 200, 100)
        CGContextAddLineToPoint(context, 200, 85)
        CGContextStrokePath(context)

        // 5
        CGContextMoveToPoint(context, 200, 140)
        CGContextAddLineToPoint(context, 250, 140)
        CGContextAddLineToPoint(context, 250, 155)
        CGContextAddLineToPoint(context, 200, 155)
        CGContextAddLineToPoint(context, 200, 140)
        CGContextStrokePath(context)

        // 6
        CGContextMoveToPoint(context, 250, 170)
        CGContextAddLineToPoint(context, 300, 170)
        CGContextAddLineToPoint(context, 300, 185)
        CGContextAddLineToPoint(context, 250, 185)
        CGContextAddLineToPoint(context, 250, 170)
        CGContextStrokePath(context)
    }
}