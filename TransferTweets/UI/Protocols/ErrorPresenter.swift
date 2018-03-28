//
//  ErrorPresenter.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import UIKit
import Swifter

protocol ErrorPresenter {
    func displayError(_ error: Error)
}

extension ErrorPresenter where Self: UIViewController {

    func displayError(_ error: Error) {
        let message: String
        if let error = error as? SwifterError {
            message = error.message
        } else if let error = error as? LocalizedError {
            message = error.errorDescription ?? error.localizedDescription
        } else {
            message = error.localizedDescription
        }

        let alertController = UIAlertController(
            title: "We're really sorry, but".localized(),
            message: message,
            preferredStyle: .alert)

        alertController.addAction(
            UIAlertAction(title: "Never mind".localized(), style: .cancel, handler: nil)
        )

        present(alertController, animated: true, completion: nil)
    }
}
