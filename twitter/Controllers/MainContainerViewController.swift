//
//  MainContainerViewController.swift
//  twitter
//
//  Created by Michael Lewis on 2/28/15.
//  Copyright (c) 2015 Machel. All rights reserved.
//

import UIKit

class MainContainerViewController: UIViewController {

  @IBOutlet weak var navMenuView: UIView!
  @IBOutlet weak var contentWindowView: UIView!

  var profileViewController: ProfileViewController!
  var homeViewController: FeedViewController!
  var mentionsViewController: FeedViewController!
  var tweetViewController: TweetViewController!

  var contentViews: [UIViewController]!

  // Pan gesture start storage
  var navMenuBeginGestureCenter: CGPoint!

  // Nav menu X boundaries (of the center)
  var navMenuLeftBound:  CGPoint!
  var navMenuRightBound: CGPoint!

  override func viewDidLoad() {
    super.viewDidLoad()

    var storyboard = UIStoryboard(name: "Main", bundle: nil)

    /* Set up the menu bar */
    // Set up our nav menu view
    self.navMenuLeftBound = self.navMenuView.center
    self.navMenuRightBound = self.navMenuLeftBound
    self.navMenuRightBound.x += 240.0

    /* Set up the content window */
    // Set up the child views for the content window
    self.profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
    self.homeViewController = storyboard.instantiateViewControllerWithIdentifier("HomeViewController") as FeedViewController
    self.mentionsViewController = storyboard.instantiateViewControllerWithIdentifier("MentionsViewController") as FeedViewController
    self.tweetViewController = storyboard.instantiateViewControllerWithIdentifier("TweetViewController") as TweetViewController

    // Set up the sub-controllers
    self.profileViewController.setUser(User.currentUser)
    self.homeViewController.setFeedType(.Home, params: nil)
    self.mentionsViewController.setFeedType(.Mentions, params: nil)

    // Collect the views together
    self.contentViews = [
      self.profileViewController,
      self.homeViewController,
      self.mentionsViewController,
      self.tweetViewController,
    ]
    // Start with these views hidden
    self.hideContentViews()
    // Set the child views as subviews of our content window and align the frame
    self.contentViews.map { (vc) -> () in
      self.contentWindowView.addSubview(vc.view)
      vc.view.frame = self.contentWindowView.frame
    }

    // Set the feed view controller as the active view
    self.activateContentView("Home", options: nil)


    // Subscribe to nav menu changes
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "handleNavMenuChange:",
      name: "menuItemSelected",
      object: nil
    )
  }

  // Handle the nav menu swiping in and out
  @IBAction func didSwipe(sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .Began:
      self.navMenuBeginGestureCenter = self.navMenuView.center
    case .Changed:
      let posChange = sender.translationInView(self.view)
      var newPos = CGPoint(
        x: self.navMenuBeginGestureCenter.x + posChange.x,
        y: self.navMenuBeginGestureCenter.y
      )

      // Bound the new position
      if newPos.x < navMenuLeftBound.x {
        newPos.x = navMenuLeftBound.x
      } else if newPos.x > navMenuRightBound.x {
        newPos.x = navMenuRightBound.x
      }

      // Assign the new position as we drag it
      self.navMenuView.center = newPos
    case .Ended:
      var velocity = sender.velocityInView(self.view)

      // Using our velocity, determine the new position we're going to
      var newPos: CGPoint
      if velocity.x > 100.0 {
        newPos = self.navMenuRightBound
      } else if velocity.x < -100.0 {
        newPos = self.navMenuLeftBound
      } else {
        // If we don't have strong velocity in either direction, just
        // topple in whatever way it's leaning, based upon the middle.
        if self.navMenuView.center.x < ((self.navMenuLeftBound.x + self.navMenuRightBound.x) / 2.0) {
          newPos = self.navMenuLeftBound
        } else {
          newPos = self.navMenuRightBound
        }
      }

      self.slideNavMenu(newPos)
    default:
      break
    }
  }

  @IBAction func onLogout(sender: AnyObject) {
    User.logout()
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "navMenuSegue":
        // Set up the delegate when we set up the nav menu controller
        var navMenuViewController = segue.destinationViewController as NavMenuViewController
        navMenuViewController.delegate = self
      default:
        break
      }
    }
  }

  func closeNavMenu() {
    self.slideNavMenu(self.navMenuLeftBound)
  }

  func handleNavMenuChange(notification: NSNotification) {
    var menuLabel = notification.object as String
    self.activateContentView(menuLabel, options: nil)
  }


  /* private below */

  private func slideNavMenu(newCenter: CGPoint) {
    UIView.animateWithDuration(0.3,
      delay: 0.0,
      usingSpringWithDamping: 1.0,
      initialSpringVelocity: 0.5,
      options: UIViewAnimationOptions.CurveEaseInOut,
      animations: { () -> Void in
        self.navMenuView.center = newCenter
      },
      completion: nil
    )
  }

  private func hideContentViews() {
    self.contentViews.map { (vc) -> () in
      vc.view.hidden = true
    }
  }

  private func activateContentView(viewName: String, options: AnyObject?) {
    self.hideContentViews()
    switch viewName {
    case "Profile":
      self.profileViewController.setUser(User.currentUser)
      self.profileViewController.view.hidden = false
    case "Home":
      self.homeViewController.view.hidden = false
    case "Mentions":
      self.mentionsViewController.view.hidden = false
    default:
      break
    }
  }
}
