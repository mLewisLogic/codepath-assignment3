//
//  NavMenuViewController.swift
//  twitter
//
//  Created by Michael Lewis on 2/28/15.
//  Copyright (c) 2015 Machel. All rights reserved.
//

import UIKit

class NavMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var menuTableView: UITableView!

  var delegate: MainContainerViewController!

  let menuLabels = [
    "Profile",
    "Home",
    "Mentions",
  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = self.menuTableView.dequeueReusableCellWithIdentifier("nav-menu.menu-item") as UITableViewCell
    cell.textLabel?.text = menuLabelAtIndexPath(indexPath)
    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuLabels.count
  }


  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    NSNotificationCenter.defaultCenter().postNotificationName(
      "menuItemSelected",
      object: menuLabelAtIndexPath(indexPath)
    )
    self.menuTableView.deselectRowAtIndexPath(indexPath, animated: true)
    self.delegate.closeNavMenu()
  }

  private func menuLabelAtIndexPath(indexPath: NSIndexPath) -> String {
    return self.menuLabels[indexPath.row]
  }
}
