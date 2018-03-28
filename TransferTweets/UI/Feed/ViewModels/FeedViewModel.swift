//
//  FeedViewModel.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias TweetChanges = ([TweetCellModel], ChangeSet)

final class TwitterFeedViewModel {

    // MARK: Properties

    private let service: FeedService

    private let tokenWriter: TokenWriter

    private var tweetList: [Tweet] = []

    private let tweetChanges = Variable<TweetChanges>(([], .none))

    private let serviceError = PublishSubject<Error>()

    private let maximumNumberOfTweets: Int = 5
    
    private var connectionDisposable: Disposable?

    // MARK: - Initialisation

    init(service: FeedService, tokenWriter: TokenWriter) {
        self.service = service
        self.tokenWriter = tokenWriter
        connectToStream()
    }

    // MARK: - Private methods
    
    private func connectToStream() {
        connectionDisposable?.dispose()
        connectionDisposable = service.openStream(track: ["transferwise"])
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
            .observeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
            .map { [weak self] tweetDto -> TweetChanges in
                guard let `self` = self
                    else { return ([], .none) }
                let tweet = self.convert(tweetDto)
                return self.insert(tweet: tweet)
            }
            .catchError { [weak self] (error) -> Observable<TweetChanges> in
                guard let `self` = self
                    else { return Observable<TweetChanges>.empty() }
                self.serviceError.onNext(error)
                return Observable<TweetChanges>.just((self.tweetList, .none))
            }
            .subscribe(onNext: { [weak self] tweetChanges in
                self?.tweetChanges.value = tweetChanges
            })
    }

    private func insert(tweet: Tweet) -> TweetChanges {
        // Filter duplications
        guard !tweetList.contains(tweet)
            else { return (tweetList, .none) }
        // Calculate deleted indicies
        let numberOfTweets = tweetList.count
        var deleted: [Int] = []
        if numberOfTweets >= maximumNumberOfTweets {
            for index in (maximumNumberOfTweets-1)..<numberOfTweets {
                deleted.append(index)
                tweetList.removeLast()
            }
        }
        // Add insertion
        let inserted: [Int] = [0]
        tweetList.insert(tweet, at: 0)
        // Return the completed list
        return (tweetList, .change(deleted: deleted, inserted: inserted))
    }

    private func convert(_ tweetDto: TweetDto) -> Tweet {
        return Tweet(
            id: tweetDto.id,
            name: tweetDto.user.name,
            userName: "@\(tweetDto.user.screenName)",
            text: tweetDto.text,
            date: tweetDto.createdAt.string,
            profileImageUrl: tweetDto.user.profileImageUrlHttps
        )
    }
}

// MARK: -

extension TwitterFeedViewModel: FeedViewModel {

    var tweets: Observable<TweetChanges> {
        return tweetChanges.asObservable()
    }

    var error: Observable<Error> {
        return serviceError.asObservable()
    }

    func logout() {
        tokenWriter.clearAccessToken()
    }
    
    func reconnect() {
        connectToStream()
    }
}
