//
//  ProfileViewController.swift
//  twitter
//
//  Created by Michael Lewis on 2/28/15.
//  Copyright (c) 2015 Machel. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var websiteLabel: UILabel!
  @IBOutlet weak var followingLabel: UILabel!
  @IBOutlet weak var followersLabel: UILabel!

  var user: User?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.loadOutlets()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "profileFeedSegue":
        // Set up the delegate when we set up the nav menu controller
        var feedViewController = segue.destinationViewController as FeedViewController
        if user != nil {
          feedViewController.setFeedType(
            TwitterClient.FeedType.Profile,
            params: ["user_name": user!.username!]
          )
        } else {
          feedViewController.setFeedType(.Profile, params: nil)
        }
      default:
        break
      }
    }
  }

  func setUser(user: User?) {
    self.user = user
    if isViewLoaded() {
      self.loadOutlets()
    }
  }

  @IBAction func backButtonActivated(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, nil)
  }

  private func loadOutlets() {
    if let user = self.user {
      if let backgroundImageUrl = user.backgroundImageUrl {
        backgroundImageView.sd_setImageWithURL(NSURL(string: backgroundImageUrl))
      }
      if let profileImageUrl = user.profileImageUrl {
        profileImageView.sd_setImageWithURL(NSURL(string: profileImageUrl))
      }
      if let name = user.name {
        nameLabel.text = name
      }
      if let handle = user.username {
        navigationItem.title = "@\(handle)"
        handleLabel.text = "@\(handle)"
      }
      if let description = user.tagline {
        descriptionLabel.text = description
      }
      if let location = user.location {
        locationLabel.text = location
      }
      if let website = user.website {
        websiteLabel.text = website
      }
      if let followingCount = user.followingCount {
        followingLabel.text = "Following: \(followingCount)"
      }
      if let followersCount = user.followersCount {
        followersLabel.text = "Following: \(followersCount)"
      }
    }
  }
}
