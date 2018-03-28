//
//  Tweet.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation

struct Tweet: TweetCellModel {
    
    var id: Int

    var name: String

    var userName: String

    var text: String

    var date: String

    var profileImageUrl: URL
}

extension Tweet: Equatable {
    static func ==(lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.id == rhs.id
    }
}
