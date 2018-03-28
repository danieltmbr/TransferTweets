//
//  FeedCoordinator.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import UIKit

// MARK: -

final class FeedCoordinator: Coordinator {

    // MARK: Properties

    let identifier: UUID = UUID()

    private let accessToken: OauthAccessToken

    private let window: UIWindow

    private var children = [UUID: Coordinator]()

    // MARK: - Initialisation

    init(window: UIWindow, accessToken: OauthAccessToken) {
        self.window = window
        self.accessToken = accessToken
    }

    // MARK: - Public methods

    func start() {
        let feedService = TwitterFeedService(
            consumerKey: TwitterConsumerInfo.key,
            consumerSecret: TwitterConsumerInfo.secret,
            oauthToken: accessToken.accessToken,
            oauthTokenSecret: accessToken.tokenSecret
        )
        let feedViewModel = TwitterFeedViewModel(
            service: feedService,
            tokenWriter: TwitterTokenManager.shared
        )
        let feedViewController = FeedViewController(viewModel: feedViewModel)
        window.rootViewController = UINavigationController(rootViewController: feedViewController)
    }

    // MARK: - Private methods

    func freeCoordinator(with id: UUID) {
        children.removeValue(forKey: id)
    }
}
