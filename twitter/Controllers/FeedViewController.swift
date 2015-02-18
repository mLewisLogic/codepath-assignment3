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

    // Reload
    feedTableView.reloadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = feedTableView.dequeueReusableCellWithIdentifier(feedTweetCellIdentifier) as FeedTweetTableViewCell
    return cell
  }
}
