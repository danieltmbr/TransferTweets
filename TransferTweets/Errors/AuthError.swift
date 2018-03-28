//
//  AuthError.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation

enum TwitterAuthError: Error {
    case noAccessToken
    case couldNotAuthorize
}

extension TwitterAuthError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .noAccessToken: return "error.twitterAuth.noAccessToken".localized()
        case .couldNotAuthorize: return "error.twitterAuth.couldNotAuthorize".localized()
        }
    }
}
