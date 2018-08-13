//
//  MainWireframe.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

class MainWireframe: BaseWireframe, MainWireframeProtocol {
    func showTweetView(from view: MainViewProtocol) {
        if let view = view as? (UIViewController & TweetViewDelegate) {
            let tweetView = TweetBuilder().createTweet()
            tweetView.delegate = view
            view.present(UINavigationController(rootViewController: tweetView), animated: true, completion: nil)
        }
    }
}
