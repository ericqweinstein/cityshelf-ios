//
//  TutorialViewController.swift
//  CityShelf
//
//  Created by Eric Weinstein <eric.q.weinstein@gmail.com>
//  Copyright (c) 2015 CityShelf. All rights reserved.
//

import UIKit

/// Manages the CityShelf tutorial shown when launching for the first time.
class TutorialViewController: UIViewController, UIPageViewControllerDataSource {
    private var tutorialViewController: UIPageViewController?

    private let instructions = [
        "Go local for books!\nCityShelf makes it easy.",
        "Tell us the title you're looking for.",
        "We'll show you which local\nbookstores have it in stock."
    ]

    private let tutorialImages = [
        "cs_intro_01.png",
        "cs_intro_02.png",
        "cs_intro_03.png"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        createTutorialViewController()
        setUpPageControl()
    }

    /**
        Only allow portrait orientation for this view.
    */
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }

    /**
        Creates the tutorial view controller.
    */
    func createTutorialViewController() {
        let tutorialController = self.storyboard!.instantiateViewControllerWithIdentifier("TutorialController") as! UIPageViewController
        tutorialController.dataSource = self

        if instructions.count > 0 {
            let firstController = getTutorialController(0)!

            let startingViewControllers: NSArray = [firstController]
            tutorialController.setViewControllers(startingViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }

        tutorialViewController = tutorialController

        addChildViewController(tutorialViewController!)
        self.view.addSubview(tutorialViewController!.view)
        tutorialViewController!.didMoveToParentViewController(self)
    }

    /**
        Sets up and configures the page control element.
    */
    func setUpPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.whiteColor()
        appearance.currentPageIndicatorTintColor = UIColor.darkGrayColor()
        appearance.backgroundColor = UIColor.grayColor()
    }

    /**
        Gets the current page view controller for the tutorial.
    */
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let tutorialController = viewController as! TutorialItemController

        if tutorialController.itemIndex > 0 {
            return getTutorialController(tutorialController.itemIndex - 1)
        }

        return nil
    }

    /**
        Gets the next page view controller for the tutorial.
    */
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let tutorialController = viewController as! TutorialItemController

        if tutorialController.itemIndex + 1 < instructions.count {
            return getTutorialController(tutorialController.itemIndex + 1)
        }

        return nil
    }

    /**
        Gets the tutorial item controller.

        :returns: The tutorial item controller.
    */
    func getTutorialController(itemIndex: Int) -> TutorialItemController? {
        if itemIndex < instructions.count {
            let tutorialItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! TutorialItemController
            tutorialItemController.itemIndex = itemIndex
            tutorialItemController.instructionText = instructions[itemIndex]
            tutorialItemController.tutorialImageText = tutorialImages[itemIndex]
            return tutorialItemController
        }

        return nil
    }

    /**
        Gets the number of screens in the tutorial sequence.

        :returns: The number of tutorial screens.
    */
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return instructions.count
    }

    /**
        Starts indexing for the tutorial sequence.

        :returns: Zero.
    */
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}