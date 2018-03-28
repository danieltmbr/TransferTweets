//
//  AppCoordinator.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 27..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import UIKit
import RxSwift

final class AppCoordinator: Coordinator {

    // MARK: Properties

    let identifier: UUID = UUID()

    private let window: UIWindow

    private let authInfo: AuthInfo

    private let disposeBag = DisposeBag()

    private var children = [UUID: Coordinator]()

    // MARK: - Initialisation

    init(window: UIWindow, authInfo: AuthInfo) {
        self.window = window
        self.authInfo = authInfo
    }

    // MARK: - Public methods

    func start() {
        setupBidings()
        window.makeKeyAndVisible()
    }

    // MARK: - Private methods

    private func setupBidings() {
        authInfo.authentication
            .catchErrorJustReturn(.none)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (authentication) in
                self?.route(authentication)
            })
            .disposed(by: disposeBag)
    }

    private func route(_ authentication: Authentication) {
        children.removeAll()
        let coordinator: Coordinator
        if case .token(let accessToken) = authentication {
            coordinator = FeedCoordinator(window: window, accessToken: accessToken)
        } else {
            coordinator = AuthCoordinator(window: window)
        }
        children[coordinator.identifier] = coordinator
        coordinator.start()
    }

    private func freeCoordinator(with id: UUID) {
        children.removeValue(forKey: id)
    }
}
