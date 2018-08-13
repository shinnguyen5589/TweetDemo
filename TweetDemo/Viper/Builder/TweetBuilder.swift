//
//  TweetBuilder.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

let MAX_TWEET_CHUNK_LENGTH: Int = 50

class TweetBuilder: TweetBuilderProtocol {
    func createTweet() -> (UIViewController & TweetViewProtocol) {
        let view = TweetViewController()
        let presenter = TweetPresenter(messageSplitter: MessageSplitter(maxChunkLength: MAX_TWEET_CHUNK_LENGTH))
        let interactor = TweetInteractor()
        let wireframe = TweetWireframe()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter
        
        return view
    }
}
