//
//  AppDelegate.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 25..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import UIKit
import Swifter

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    private var appCoordinator: Coordinator!

    // MARK: - Public methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        appCoordinator = AppCoordinator(
            window: UIWindow(),
            authInfo: TwitterTokenManager.shared
        )
        appCoordinator.start()
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        Swifter.handleOpenURL(url)
        return true
    }
}
