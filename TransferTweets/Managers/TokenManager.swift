//
//  TokenManager.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthInfo {
    /** Indicates if the user has been already authenticated */
    var isAuthenticated: Observable<Bool> { get }
}

protocol TokenReader: AuthInfo {
    /** Returns OAuth access token if the user has been already authenticated */
    var accessToken: Observable<OauthAccessToken?> { get }
}

protocol TokenWriter {
    /** Sets access token */
    func setAccessToken(_ accessToken: OauthAccessToken)
    /** Clear the current access token */
    func clearAccessToken()
}

typealias TokenManager = TokenReader & TokenWriter
