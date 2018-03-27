//
//  AuthCoordinator.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 27..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import UIKit

// MARK: -

final class AuthCoordinator: Coordinator {

    // MARK: Properties

    let identifier: UUID = UUID()

    private var children = [UUID: Coordinator]()

    private let window: UIWindow

    // MARK: - Initialisation

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Public methodsr

    func start() {
        let authService = TwitterAuthService(
            consumerKey: "QQt2eDN6L3sJg0ewa7alDRqAq",
            consumerSecret: "juLldKBdnoY3Sqj8FsRWCAlEurtNe1n0u6FQRywcojabPRpNVB"
        )
        let authViewModel = TwitterAuthViewModel(
            service: authService,
            tokenWriter: TwitterTokenManager.shared
        )
        window.rootViewController = AuthViewController(with: authViewModel)
    }

    // MARK: - Private methods

    func freeCoordinator(with id: UUID) {
        children.removeValue(forKey: id)
    }
}
