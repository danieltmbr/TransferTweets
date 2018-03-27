//
//  Coordinator.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 27..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation

protocol Coordinator: class {

    var identifier: UUID { get }

    func start()
}
