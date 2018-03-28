//
//  AuthViewController.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 27..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: -

protocol AuthViewModel {
    /** Error occured during the login process. (output) */
    var error: Driver<Error> { get }
    /** Handle login button touched. (input) */
    var loginTouched: AnyObserver<Void> { get }
}

// MARK: -

final class AuthViewController: UIViewController, ErrorPresenter {

    // MARK: Properties

    /** Business logic */
    private let viewModel: AuthViewModel
    /** Disposables collector */
    private let disposeBag = DisposeBag()

    // MARK: - IBOutlets

    @IBOutlet weak private var loginButton: UIButton!

    // MARK: - Initialisation

    init(with viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AuthViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.setTitle("Login with Twitter".localized(), for: .normal)
        setupBidings()
    }

    // MARK: - Private methods

    private func setupBidings() {

        // Handle login button touch up inside
        loginButton.rx
            .controlEvent(.touchUpInside)
            .debounce(0.75, scheduler: MainScheduler.asyncInstance)
            .bind(to: viewModel.loginTouched)
            .disposed(by: disposeBag)

        // Display error if happens
        viewModel.error
            .drive(onNext: { [weak self] (error) in
                self?.displayError(error)
            })
            .disposed(by: disposeBag)
    }
}
