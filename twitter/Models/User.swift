//
//  User.swift
//  twitter
//
//  Created by Michael Lewis on 2/21/15.
//  Copyright (c) 2015 Machel. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"

let userDidLoginNotification = "notify.user.did-login"
let userDidLogoutNotification = "notify.user.did-logout"

class User: NSObject {

  var dict: NSDictionary

  var name: String?
  var username: String?
  var profileImageUrl: String?
  var tagline: String?

  init(dict: NSDictionary) {
    self.dict = dict
    name = dict["name"] as String?
    username = dict["screen_name"] as String?
    profileImageUrl = dict["profile_image_url"] as String?
    tagline = dict["description"] as String?
  }

  class func logout() {
    currentUser = nil
    TwitterClientManager.sharedClient?.requestSerializer.removeAccessToken()

    NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
  }

  func tweet(status: String) {
    TwitterClientManager.sharedClient?.tweetWithCompletion(
      status,
      completion: {
        (response, error) -> () in
        if error == nil {
          println("Tweet successful: \(response)")
        } else {
          println("Tweet failed: \(error)")
        }
      }
    )
  }

  class var currentUser: User? {
    get {
      if _currentUser == nil {
        var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as NSData?
        if data != nil {
          var dict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
          _currentUser = User(dict: dict)
        }
      }
      return _currentUser
    }
    set(user) {
      _currentUser = user

      var data: AnyObject?
      if user != nil {
        data = NSJSONSerialization.dataWithJSONObject(user!.dict, options: nil, error: nil)
      } else {
        data = nil
      }

      // Set the data and synchronize
      NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
      NSUserDefaults.standardUserDefaults().synchronize()
    }
  }
}
