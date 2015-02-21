//
//  TwitterClient.swift
//  twitter
//
//  Created by Michael Lewis on 2/21/15.
//  Copyright (c) 2015 Machel. All rights reserved.
//

import Foundation


class TwitterClientManager {
  // Create a shared static instance of this client
  class var sharedClient: TwitterClient? {
    struct Static {
      // Create an instance of the client for shared use
      static var instance: TwitterClient? = {
        if let settings = TwitterClientManager.loadSettings() {
          if let twitterSettings = settings["Twitter"] as? Dictionary<String, String> {
            return TwitterClient(
              baseURL: NSURL(string: "https://api.twitter.com"),
              consumerKey: twitterSettings["consumer_key"],
              consumerSecret: twitterSettings["consumer_secret"]
            )
          } else {
            NSLog("Missing credentials node in private.plist file. Expect access to fail.")
          }
        } else {
          NSLog("Missing valid private.plist file. Expect access to fail.")
        }

        return nil
      }()
    }

    return Static.instance?
  }

  // Pull our private credential settings as a Dictionary.
  class func loadSettings() -> Dictionary<String, AnyObject>? {
    if let path = NSBundle.mainBundle().pathForResource("private", ofType: "plist") {
      if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
        // If we got this far, we have a valid dict
        return dict
      }
    }

    return nil
  }



}

class TwitterClient: BDBOAuth1SessionManager {
  typealias LoginCompletionHandlerType = (user: User?, error: NSError?) -> ()

  var loginCompletionHandler: LoginCompletionHandlerType?

  // Handle the entire OAuth dance
  func loginWithCompletion(completion: LoginCompletionHandlerType) {
    // Save the completion handler for later
    loginCompletionHandler = completion

    // fetch request token and redirect to authorization page
    requestSerializer.removeAccessToken()
    fetchRequestTokenWithPath(
      "oauth/request_token",
      method: "GET",
      callbackURL: NSURL(string: "cptwitterdemo://oauth"),
      scope: nil,
      success: { (request_token: BDBOAuth1Credential!) in
        println("Got request token: \(request_token)")
        let authUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(request_token.token)")!
        UIApplication.sharedApplication().openURL(authUrl)
      },
      failure: { (error: NSError!) in
        println("Error getting request token: \(error)")
        self.loginCompletionHandler?(user: nil, error: error)
      }
    )
  }

  // Handle the callback URL
  func openCallbackURL(url: NSURL) {
    TwitterClientManager.sharedClient?.fetchAccessTokenWithPath(
      "oauth/access_token",
      method: "POST",
      requestToken: BDBOAuth1Credential(queryString: url.query),
      success: { (access_token: BDBOAuth1Credential!) in
        println("Got access token: \(access_token.description)")
        self.requestSerializer.saveAccessToken(access_token)

        // Load the user
        self.GET(
          "1.1/account/verify_credentials.json",
          parameters: nil,
          success: {
            (task: NSURLSessionDataTask!, response: AnyObject!) in
            var user = User(dict: response as NSDictionary)
            println("Got user: \(user.name)")
            self.loginCompletionHandler?(user: user, error: nil)
          },
          failure: {
            (task: NSURLSessionDataTask!, error: NSError!) in
            self.loginCompletionHandler?(user: nil, error: error)
            () // Swift... sigh.
          }
        )
      },
      failure: { (error: NSError!)in
        println("Error getting access token: \(error.description)")
        self.loginCompletionHandler?(user: nil, error: error)
      }
    )
  }
}