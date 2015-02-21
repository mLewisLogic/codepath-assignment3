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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  @IBAction func onLogin(sender: AnyObject) {
    TwitterClientManager.sharedClient?.loginWithCompletion() {
      (user: User?, error: NSError?) in
      if user != nil {
        println("Login completion with user: \(user?.name)")
        // segue
      } else {
        println("Login error: \(error?.description)")
        // error
      }
    }
  }
}
