//
//  UserDto.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation
import Swifter

struct UserDto: Codable {

    let id: Int
    let name: String
    let screenName: String
    let profileImageUrlHttps: URL

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case screenName = "screen_name"
        case profileImageUrlHttps = "profile_image_url_https"
    }

    init(json: JSON) throws {
        guard let id = json[CodingKeys.id.rawValue].integer,
            let name = json[CodingKeys.name.rawValue].string,
            let screenName = json[CodingKeys.screenName.rawValue].string,
            let imageUrl = json[CodingKeys.profileImageUrlHttps.rawValue].string,
            let profileImageUrlHttps = URL(string: imageUrl)
            else { throw ParseError.invalidJson }

        self.id = id
        self.name = name
        self.screenName = screenName
        self.profileImageUrlHttps = profileImageUrlHttps
    }
}
