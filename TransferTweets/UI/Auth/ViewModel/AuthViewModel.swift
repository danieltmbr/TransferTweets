//
//  AuthViewModel.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 27..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TwitterAuthViewModel {

    // MARK: Properties

    private let service: AuthService

    private let tokenWriter: TokenWriter

    private let loginError = PublishSubject<Error>()

    private let loginButtonTouchEvents = PublishSubject<Void>()

    private let disposeBag = DisposeBag()

    // MARK: - Initialisation

    init(service: AuthService, tokenWriter: TokenWriter) {
        self.service = service
        self.tokenWriter = tokenWriter
        setupBidings()
    }

    // MARK: - Private methods

    private func setupBidings() {
        loginButtonTouchEvents.asObserver()
            .flatMapLatest { [weak self] _ -> Observable<OauthAccessToken> in
                guard let `self` = self else { return Observable.empty() }
                return self.service.login()
            }
            .subscribe(
                onNext: { [weak self] token in
                    self?.tokenWriter.setAccessToken(token)
                },
                onError: { [weak self] error in
                    self?.loginError.onNext(error)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: -

extension TwitterAuthViewModel: AuthViewModel {

    var error: Driver<Error> {
        return loginError.asDriver(onErrorRecover: { Driver<Error>.just($0) })
    }

    var loginTouched: AnyObserver<Void> {
        return loginButtonTouchEvents.asObserver()
    }
}
