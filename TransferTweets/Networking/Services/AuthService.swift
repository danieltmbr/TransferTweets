//
//  AuthService.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 26..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation
import Swifter
import RxSwift

// MARK: -

protocol AuthService {
    /** Authenticate to Twitter */
    func login() -> Observable<OauthAccessToken>
}

// MARK: -

final class TwitterAuthService {

    private let swifter: Swifter

    init(consumerKey key: String, consumerSecret secret: String) {
        swifter = Swifter(consumerKey: key, consumerSecret: secret)
    }
}

// MARK: -

extension TwitterAuthService: AuthService {

    func login() -> Observable<OauthAccessToken> {
        return Observable<OauthAccessToken>.create { [weak self] observer in
            guard let `self` = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            self.swifter.authorize(
                with: URL(string: "transfertweets://success")!,
                presentFrom: nil,
                success: { (token, response) in
                    guard let token = token
                        else { return observer.onError(TwitterAuthError.noAccessToken) }
                    observer.onNext(token)
                },
                failure: {  observer.onError($0) }
            )
            return Disposables.create()
        }
    }
}
