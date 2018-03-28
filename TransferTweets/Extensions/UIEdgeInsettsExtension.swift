//
//  UIEdgeInsettsExtension.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    var sumHorizontal: CGFloat {
        return left + right
    }

    var sumVertical: CGFloat {
        return top + bottom
    }
}
