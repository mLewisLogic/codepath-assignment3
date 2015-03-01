//
//  FeedTweetTableViewCell.swift
//  twitter
//
//  Created by Michael Lewis on 2/18/15.
//  Copyright (c) 2015 Machel. All rights reserved.
//

import UIKit

class FeedTweetTableViewCell: UITableViewCell {

  // The retweet display at the top of the cell
  @IBOutlet weak var retweetInfoView: UIView!
  @IBOutlet weak var retweetInfoViewImage: UIImageView!
  @IBOutlet weak var retweetInfoViewLabel: UILabel!

  // The tweet itself
  @IBOutlet weak var tweetView: UIView!
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userHandleLabel: UILabel!
  @IBOutlet weak var tweetAgeLabel: UILabel!
  @IBOutlet weak var tweetContentsLabel: UILabel!

  // Tweet controls
  @IBOutlet weak var controlsView: UIView!
  @IBOutlet weak var replyButton: UIButton!
  @IBOutlet weak var retweetButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!

  var tweet: Tweet!
  var controllerDelegate: FeedViewController!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    let recognizer = UITapGestureRecognizer(
      target: self,
      action:Selector("handleUserImageTapped:")
    )
    recognizer.delegate = self
    profileImageView.addGestureRecognizer(recognizer)
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

  func setTweet(tweet: Tweet) {
    self.tweet = tweet
    loadTweetIntoView(tweet)
  }

  func handleUserImageTapped(sender: UITapGestureRecognizer) {
    if let author = tweet.author {
      controllerDelegate.showUserProfile(author)
    }
  }


  private func loadTweetIntoView(tweet: Tweet) {
    if let retweeted = tweet.retweeted {
      if retweeted {
        retweetInfoView.frame.size.height = 20
        retweetInfoView.hidden = false
      } else {
        retweetInfoView.frame.size.height = 0
        retweetInfoView.hidden = true
      }
    }

    if let author = tweet.author {
      if let profileImageUrl = author.profileImageUrl {
        profileImageView.sd_setImageWithURL(NSURL(string: profileImageUrl))
      }
      if let name = author.name {
        userNameLabel.text = name
      }
      if let username = author.username {
        userHandleLabel.text = "@\(username)"
      }
    }

    if let createdAt = tweet.createdAt {
      let calendar = NSCalendar.currentCalendar()
      let today = NSDate()
      let components = calendar.components(
        .YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit,
        fromDate: createdAt,
        toDate: today,
        options: nil
      )

      var ageString: String
      if components.year > 0 {
        ageString = "\(components.year)y"
      } else if components.month > 0 {
        ageString = "\(components.month)m"
      } else if components.day > 0 {
        ageString = "\(components.day)d"
      } else if components.hour > 0 {
        ageString = "\(components.hour)h"
      } else if components.minute > 0 {
        ageString = "\(components.minute)m"
      } else if components.second > 0 {
        ageString = "\(components.second)s"
      } else {
        ageString = ""
      }
      tweetAgeLabel.text = ageString
    }

    if let text = tweet.text {
      tweetContentsLabel.text = text
      tweetContentsLabel.sizeToFit()
    }
  }

}
