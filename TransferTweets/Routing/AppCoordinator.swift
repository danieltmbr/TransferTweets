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

    private var children = [UUID: Coordinator]()

    private let window: UIWindow

    private let authInfo: AuthInfo

    private let disposeBag = DisposeBag()

    // MARK: - Initialisation

    init(window: UIWindow, authInfo: AuthInfo) {
        self.window = window
        self.authInfo = authInfo
    }

    // MARK: - Public methodsr

    func start() {
        setupBidings()
        window.makeKeyAndVisible()
    }

    // MARK: - Private methods

    private func setupBidings() {
        authInfo.isAuthenticated
            .catchErrorJustReturn(false)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (isAuthenticated) in
                self?.route(isAuthenticated: isAuthenticated)
            })
            .disposed(by: disposeBag)
    }

    private func route(isAuthenticated: Bool) {
        children.removeAll()
        let coordinator: Coordinator = isAuthenticated
            ? AuthCoordinator(window: window)
            : FeedCoordinator(window: window)
        children[coordinator.identifier] = coordinator
        coordinator.start()
    }

    private func freeCoordinator(with id: UUID) {
        children.removeValue(forKey: id)
    }
}
