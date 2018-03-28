# TransferTweets
iOS test app fot TransferWise

### Task
Twitter provides an endpoint that delivers a continuous stream of tweets filtered by a keyword (https://stream.twitter.com/1.1/statuses/filter.json?track=transferwise)

Using the latest version of Swift build an iOS application in your usual coding style that shows a realtime display of the latest 5 tweets associated with this keyword.

### Features

* Twitter OAuth authentication
* Twitter Stream for "transferwise" keyword
    * Update collectionview with batch update
    * Showing no more than 5 tweets
    * Filter duplications from stream events
    * Displaying alert at errors
* MVVM Design pattern with FRP
* Navigation with Coordinators
* POP approach

### What is missing?

* Unfortunatelly no tests were written (due to lack of time, sorry about that)
* Lost connection / Reachability handling
* Reconnecting to lost stream

### How to try it out?

0. If checked out from the [GitHub repo](https://github.com/danieltmbr/TransferTweets): You have to install dependencies by `pod install` in terminal
1. Open TransferTweets.xcworkspace
2. Build and Run the aplication on Simulator or Device, with iOS 11.0 or later
3. At login screen tap on "Login with Twitter" button then Authorize the application
4. If your're logged in, with another device open [Twitter](https://twitter.com) in your webbrowser 
 and post something that contains the word "transferwise". E.g.: "transferwise test app".
5. You're tweets going to appear in the application, no more than 5 of them at once.

### Dependencies

* [RxSwift](https://github.com/ReactiveX/RxSwift)
* [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/master/RxCocoa)
* [Swifter](https://github.com/mattdonnelly/Swifter)
* [Kingfisher](https://github.com/onevcat/Kingfisher)
* [ActionLabel](https://github.com/optonaut/ActiveLabel.swift)
