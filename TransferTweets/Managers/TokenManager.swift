//
//  TokenManager.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation
import RxSwift

enum Authentication {
    case none
    case token(OauthAccessToken)
}

protocol AuthInfo {
    /** Returns authentication state (either 'none' or an access token) */
    var authentication: Observable<Authentication> { get }
}

protocol TokenWriter {
    /** Sets access token */
    func setAccessToken(_ accessToken: OauthAccessToken)
    /** Clear the current access token */
    func clearAccessToken()
}

typealias TokenManager = AuthInfo & TokenWriter
