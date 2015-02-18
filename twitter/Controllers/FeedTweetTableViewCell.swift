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


  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
