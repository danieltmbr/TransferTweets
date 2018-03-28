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

    private var tweetList: [TweetCellModel] = []

    private let tweetChanges = Variable<TweetChanges>(([], .none))

    private let serviceError = PublishSubject<Error>()

    private let maximumNumberOfTweets: Int = 5

    private let disposeBag = DisposeBag()

    // MARK: - Initialisation

    init(service: FeedService, tokenWriter: TokenWriter) {
        self.service = service
        self.tokenWriter = tokenWriter
        setupBidings()
    }

    // MARK: - Private methods

    func setupBidings() {
//        service = TwitterFeedService(
//            consumerKey: "QQt2eDN6L3sJg0ewa7alDRqAq",
//            consumerSecret: "juLldKBdnoY3Sqj8FsRWCAlEurtNe1n0u6FQRywcojabPRpNVB",
//            oauthToken: TwitterTokenManager.shared._accessToken!.accessToken,
//            oauthTokenSecret: TwitterTokenManager.shared._accessToken!.tokenSecret)
//        service?.openStream(track: ["transferwise", "crypto", "life", "photo"])
//            .subscribe(onNext: { (tweet) in
//                print(tweet)
//            }, onError: { (error) in
//                print(error)
//            })
//            .disposed(by: disposeBag)
    }

    private func insert(tweet: TweetDto) -> TweetChanges {
        tweetList.insert(convert(tweet), at: 0)
        let numberOfTweets = tweetList.count
        let inserted: [Int] = [0]
        var deleted: [Int] = []
        if numberOfTweets > maximumNumberOfTweets {
            for index in maximumNumberOfTweets..<numberOfTweets {
                deleted.append(index)
                tweetList.removeLast()
            }
        }
        return (tweetList, .change(deleted: deleted, inserted: inserted))
    }

    private func convert(_ tweetDto: TweetDto) -> TweetCellModel {
        return Tweet(
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

    var tweets: Driver<TweetChanges> {
        return service.openStream(track: ["transferwise", "crypto", "life"])
            .map { [weak self] tweet -> TweetChanges in
                guard let `self` = self
                    else { return ([], .reload) }
                return self.insert(tweet: tweet)
            }
            .asDriver { [weak self] (error) -> Driver<TweetChanges> in
                guard let `self` = self
                    else { return Driver<TweetChanges>.empty() }
                self.serviceError.onNext(error)
                return Driver<TweetChanges>.just((self.tweetList, .none))
        }
    }

    var error: Driver<Error> {
        return serviceError.asDriver(onErrorRecover: { Driver<Error>.just($0) })
    }

    func logout() {
        tokenWriter.clearAccessToken()
    }
}
