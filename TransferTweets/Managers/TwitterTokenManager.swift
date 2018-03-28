//
//  TwitterTokenManager.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation
import RxSwift

final class TwitterTokenManager {

    // MARK: - Properties

    /** Singleton object */
    static let shared = TwitterTokenManager()
    /** Current access token */
    private let token = Variable<Authentication>(.none)

    // MARK: - Initialisation

    private init() { }
}

// MARK: -

extension TwitterTokenManager: TokenManager {

    var authentication: Observable<Authentication> {
        return token.asObservable()
    }

    func setAccessToken(_ accessToken: OauthAccessToken) {
        token.value = .token(accessToken)
    }

    func clearAccessToken() {
        token.value = .none
    }
}
