//
//  ComposeViewController.swift
//  twitter
//
//  Created by Michael Lewis on 2/18/15.
//  Copyright (c) 2015 Machel. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {


  @IBOutlet weak var composeTextField: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  @IBAction func onCancel(sender: AnyObject) {
    dismissViewControllerAnimated(true, nil)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "tweetToHomeSegue" {
      User.currentUser?.tweet(composeTextField.text)
    }
  }
}
