//
//  OauthAccessToken.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation
import Swifter

// MARK: -

protocol OauthAccessToken {
    /** OAuth access token key */
    var accessToken: String { get }
    /** OAuth access token secret */
    var tokenSecret: String { get }
    /** Authenticated user's display name */
    var userName: String? { get }
    /** Authenticated user's id */
    var userId: String? { get }
}

// MARK: -

extension Credential.OAuthAccessToken: OauthAccessToken {

    var accessToken: String {
        return key
    }

    var tokenSecret: String {
        return secret
    }

    var userName: String? {
        return screenName
    }

    var userId: String? {
        return userID
    }
}
