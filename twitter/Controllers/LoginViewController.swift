//
//  LoginViewController.swift
//  twitter
//
//  Created by Michael Lewis on 2/21/15.
//  Copyright (c) 2015 Machel. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func onLogin(sender: AnyObject) {
    TwitterClientManager.sharedClient?.loginWithCompletion() {
      (user: User?, error: NSError?) in
      if user != nil {
        println("Login completion with user: \(user?.name)")
        self.performSegueWithIdentifier("loginSegue", sender: self)
      } else {
        println("Login error: \(error?.description)")
        // error
      }
    }
  }
}
