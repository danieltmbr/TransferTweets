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

    private let window: UIWindow

    private var children = [UUID: Coordinator]()

    // MARK: - Initialisation

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - Public methods

    func start() {
        let authService = TwitterAuthService(
            consumerKey: TwitterConsumerInfo.key,
            consumerSecret: TwitterConsumerInfo.secret
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
