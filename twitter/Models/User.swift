//
//  User.swift
//  twitter
//
//  Created by Michael Lewis on 2/21/15.
//  Copyright (c) 2015 Machel. All rights reserved.
//

import UIKit

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
}
