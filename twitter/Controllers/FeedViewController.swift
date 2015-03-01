//
//  FeedViewController.swift
//  twitter
//
//  Created by Michael Lewis on 2/18/15.
//  Copyright (c) 2015 Machel. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var feedTableView: UITableView!

  var refreshControl: UIRefreshControl!

  var feedType: TwitterClient.FeedType!
  var params: NSDictionary?

  var tweets: [Tweet]?

  var userToSegueTo: User?

  let feedTweetCellNibName = "FeedTweetTableViewCell"
  let feedTweetCellIdentifier = "com.machel.twitter.feed.tweet"

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    // Register our external RestaurantTableViewCell xib
    feedTableView.registerNib(
      UINib(
        nibName: feedTweetCellNibName,
        bundle: NSBundle.mainBundle()
      ),
      forCellReuseIdentifier: feedTweetCellIdentifier
    )

    // Set up automatic row height
    feedTableView.rowHeight = UITableViewAutomaticDimension

    // Set up pull to refresh
    refreshControl = UIRefreshControl()
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    feedTableView.addSubview(refreshControl)

    // Default to a home view
    self.feedType = .Home
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets?.count ?? 0
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = feedTableView.dequeueReusableCellWithIdentifier(feedTweetCellIdentifier) as FeedTweetTableViewCell
    cell.controllerDelegate = self
    if tweets != nil {
      cell.setTweet(tweets![indexPath.row])
    }

    return cell
  }

  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("tweetDetailSegue", sender: self)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let identifier = segue.identifier {
      switch identifier {
      case "tweetDetailSegue":
        var childController = segue.destinationViewController as TweetViewController
        childController.setTweet(tweets![feedTableView.indexPathForSelectedRow()!.row])
      case "profileViewSegue":
        if userToSegueTo != nil {
          var navController = segue.destinationViewController as UINavigationController
          var profileController = navController.childViewControllers[0] as ProfileViewController
          profileController.setUser(userToSegueTo)
        }
        userToSegueTo = nil
      default:
        break
      }
    }
  }

  func setFeedType(type: TwitterClient.FeedType, params: NSDictionary?) {
    self.feedType = type
    self.params = params
    self.refresh()
  }

  func refresh() {
    TwitterClientManager.sharedClient?.feedWithParams(
      self.params,
      feedType: self.feedType,
      completion: {
        (tweets, error) -> () in
        if tweets != nil {
          self.tweets = tweets
          self.feedTableView.reloadData()
        }

        if error != nil {
          println("Error loading feed: \(error?.description)")
        }
        self.refreshControl.endRefreshing()
      }
    )
  }

  func showUserProfile(user: User) {
    userToSegueTo = user
    performSegueWithIdentifier("profileViewSegue", sender: self)
  }
}
