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
    private let token = Variable<OauthAccessToken?>(nil)

    // MARK: - Initialisation

    private init() { }
}

// MARK: -

extension TwitterTokenManager: TokenManager {

    var isAuthenticated: Observable<Bool> {
        return token.asObservable().map { $0 != nil }
    }

    var accessToken: Observable<OauthAccessToken?> {
        return token.asObservable()
    }

    func setAccessToken(_ accessToken: OauthAccessToken) {
        token.value = accessToken
    }

    func clearAccessToken() {
        token.value = nil
    }
}
