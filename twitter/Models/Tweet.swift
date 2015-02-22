//
//  Tweet.swift
//  twitter
//
//  Created by Michael Lewis on 2/21/15.
//  Copyright (c) 2015 Machel. All rights reserved.
//

import UIKit

class Tweet: NSObject {

  var author: User?
  var text: String?
  var createdAtString: String?
  var createdAt: NSDate?
  var retweeted: Bool?
  var retweet_count: Int?
  var favorited: Bool?
  var favorite_count: Int?


  init(dict: NSDictionary) {
    super.init()

    author = User(dict: dict["user"] as NSDictionary)
    text = dict["text"] as String?
    createdAtString = dict["created_at"] as String?
    createdAt = self.createdAtToNSDate(createdAtString!)
    retweeted = dict["retweeted"] as Bool?
    retweet_count = dict["retweet_count"] as Int?
    favorited = dict["favorited"] as Bool?
    favorite_count = dict["favorite_count"] as Int?
  }

  func createdAtToNSDate(created_at: String) -> NSDate? {
    var formatter = NSDateFormatter()
    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    return formatter.dateFromString(created_at)
  }
   
}
