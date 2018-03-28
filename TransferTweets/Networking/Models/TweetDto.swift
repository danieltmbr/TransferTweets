//
//  TweetDto.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation
import Swifter

struct TweetDto: Codable {

    let id: Int
    let text: String
    let user: UserDto
    let createdAt: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case user
        case createdAt = "created_at"
    }

    init(json: JSON) throws {
        guard let id = json[CodingKeys.id.rawValue].integer,
            let text = json[CodingKeys.text.rawValue].string,
            let createdAt = json[CodingKeys.createdAt.rawValue].string,
            let date = Date(twitterDate: createdAt)
            else { throw ParseError.invalidJson }

        self.id = id
        self.text = text
        self.user = try UserDto(json: json[CodingKeys.user.rawValue])
        self.createdAt = date
    }
}




