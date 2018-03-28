//
//  TweetCollectionViewCell.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import UIKit
import ActiveLabel
import Kingfisher

// MARK: -

protocol TweetCellModel {
    /** Name of the user */
    var name: String { get }
    /** Screen/username of the user */
    var userName: String { get }
    /** Tweet's content */
    var text: String { get }
    /** Posted date */
    var date: String { get }
    /** User's profile image url */
    var profileImageUrl: URL { get }
}

// MARK: -

final class TweetCollectionViewCell: UICollectionViewCell, ExternalCell {

    static let sizingCell = TweetCollectionViewCell.loadFromNib()

    private var sizingWidthConstraint: NSLayoutConstraint? = nil

    // MARK: IBOutlets

    @IBOutlet weak private var userImageView: UIImageView!

    @IBOutlet weak private var nameLabel: UILabel!

    @IBOutlet weak private var userNameLabel: UILabel!

    @IBOutlet weak private var textLabel: ActiveLabel!

    @IBOutlet weak private var dateLabel: UILabel!

    // MARK: - Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextLabel()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clear()
    }

    func render(tweet: TweetCellModel) {
        userImageView.kf.setImage(with: tweet.profileImageUrl)
        nameLabel.text = tweet.name
        userNameLabel.text = tweet.userName
        textLabel.text = tweet.text
        dateLabel.text = tweet.date
    }

    // MARK: - Private methods

    private func setupTextLabel() {
        textLabel.enabledTypes = [.hashtag, .url, .mention]
        textLabel.handleURLTap {
            UIApplication.shared.open($0, options: [:], completionHandler: nil)
        }
    }

    private func clear() {
        userImageView.image = nil
        nameLabel.text = nil
        userNameLabel.text = nil
        textLabel.text = nil
        dateLabel.text = nil
    }

}

// MARK: - Sizing

extension TweetCollectionViewCell {

    func size(for width: CGFloat, tweet: TweetCellModel) -> CGSize {
        if sizingWidthConstraint == nil {
            sizingWidthConstraint = NSLayoutConstraint(
                item: self, attribute: .width, relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute,
                multiplier: 1.0, constant: width)
            sizingWidthConstraint?.isActive = true
        }

        if sizingWidthConstraint?.constant != width {
            sizingWidthConstraint?.constant = width
        }

        render(tweet: tweet)
        return self.systemLayoutSizeFitting(
            UILayoutFittingCompressedSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
    }
}
