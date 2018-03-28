//
//  FeedViewController.swift
//  TransferTweets
//
//  Created by Daniel Tombor on 2018. 03. 28..
//  Copyright © 2018. danieltmbr. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: -

enum ChangeSet {
    case none
    case reload
    case change(deleted: [Int], inserted: [Int])
}

// MARK: -

protocol FeedViewModel {
    /** Tweet list and changes compared to previous */
    var tweets: Observable<([TweetCellModel], ChangeSet)> { get }
    /** Stream error */
    var error: Observable<Error> { get }
    /** Close connection if available and try open a new stream. */
    func reconnect()
    /** Handle logout button touched. */
    func logout()
}

// MARK: -

final class FeedViewController: UIViewController, ErrorPresenter {

    private struct Config {
        let spacing: CGFloat = 10
        let insets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    // MARK: Properties

    /** */
    private let config = Config()
    /** Data */
    private var tweets: [TweetCellModel] = []
    /** Business logic */
    private let viewModel: FeedViewModel
    /** Disposables collector */
    private let disposeBag = DisposeBag()

    // MARK: - IBOutlets

    @IBOutlet weak private var tweetsCollectionView: UICollectionView!

    // MARK: - Initialisation

    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "FeedViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupCollectionView()
        setupBidings()
    }

    // MARK: - Private methods
    
    private func setupNavbar() {
        title = "Transfer Tweets".localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Logout".localized(),
            style: .plain,
            target: self,
            action: #selector(logoutTouched)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Reconnect".localized(),
            style: .plain,
            target: self,
            action: #selector(reconnectTouched)
        )
    }

    private func setupCollectionView() {
        tweetsCollectionView.registerCell(TweetCollectionViewCell.self)
    }

    private func setupBidings() {
        // Handle incoming tweets
        viewModel.tweets
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] (tweets, changes) in
                self?.updateCollectionView(tweets: tweets, changes: changes)
            })
            .disposed(by: disposeBag)
        // Handle errors if happened
        viewModel.error
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] error in
                self?.displayError(error)
            })
            .disposed(by: disposeBag)
    }

    private func updateCollectionView(tweets: [TweetCellModel], changes: ChangeSet) {
        switch changes {
        case .change(let deleted, let inserted):
            tweetsCollectionView.performBatchUpdates({
                self.tweets = tweets
                self.tweetsCollectionView
                    .deleteItems(at: deleted.map { IndexPath(int: $0) } )
                self.tweetsCollectionView
                    .insertItems(at: inserted.map { IndexPath(int: $0) } )
            })
        case .reload:
            self.tweets = tweets
            tweetsCollectionView.reloadData()
        case .none: break
        }
    }

    @objc
    private func logoutTouched() {
        viewModel.logout()
    }
    
    @objc
    private func reconnectTouched() {
        viewModel.reconnect()
    }
}

// MARK: - UICollectionViewDataSource

extension FeedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: TweetCollectionViewCell = collectionView.dequeueExternalCell(for: indexPath)
            else { fatalError("Please check your collection view and cells") }
        cell.render(tweet: tweets[indexPath.item])
        return cell
    }
}

// MARK: -

extension FeedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return config.spacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return config.insets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - config.insets.sumHorizontal
        return TweetCollectionViewCell.sizingCell
            .size(for: width, tweet: tweets[indexPath.item])
    }
}

// MARK: - IndexPath extension

private extension IndexPath {
    init(int: Int) {
        self = IndexPath(item: int, section: 0)
    }
}
