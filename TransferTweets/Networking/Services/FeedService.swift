//
//  FeedService.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation
import Swifter
import RxSwift

// MARK: -

protocol FeedService {
    /** Establish stream and get tweets */
    func openStream(track: [String]) -> Observable<TweetDto>
}

// MARK: -

final class TwitterFeedService {

    // MARK: Properties

    private var stream: HTTPRequest?

    private let swifter: Swifter

    // MARK: - Initialisation

    init(consumerKey key: String, consumerSecret secret: String,
        oauthToken token: String, oauthTokenSecret tokenSecret:String) {
        swifter = Swifter(
            consumerKey: key,
            consumerSecret: secret,
            oauthToken: token,
            oauthTokenSecret: tokenSecret)
    }

    deinit {
        stopStream()
    }

    // MARK: - Private methods

    private func stopStream() {
        stream?.stop()
    }
}

// MARK: -

extension TwitterFeedService: FeedService {

    func openStream(track: [String]) -> Observable<TweetDto> {
        stopStream()
        return Observable<TweetDto>.create { [weak self] observer in
            guard let `self` = self else {
                observer.onCompleted()
                return Disposables.create()
            }

            self.stream = self.swifter.postTweetFilters(
                track: track,
                progress: { json in
                    guard let tweet = try? TweetDto(json: json)
                        else { return }
                    observer.onNext(tweet)
                },
                failure: { error in
                    observer.onError(error)
            })

            self.stream?.start()
            return Disposables.create()
        }
    }
}
