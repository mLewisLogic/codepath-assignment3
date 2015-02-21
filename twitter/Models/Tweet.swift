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

  init(dict: NSDictionary) {
    super.init()

    author = User(dict: dict["user"] as NSDictionary)
    text = dict["description"] as String?
    createdAtString = dict["created_at"] as String?

    createdAt = self.createdAtToNSDate(createdAtString!)
  }

  func createdAtToNSDate(created_at: String) -> NSDate? {
    var formatter = NSDateFormatter()
    formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
    return formatter.dateFromString(created_at)
  }
   
}
