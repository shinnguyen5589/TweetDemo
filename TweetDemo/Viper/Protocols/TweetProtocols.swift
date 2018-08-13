//
//  TweetProtocols.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

// BUILDER
protocol TweetBuilderProtocol: BaseBuilderProtocol {
    func createTweet() -> (UIViewController & TweetViewProtocol)
}

// WIREFRAME
protocol TweetWireframeProtocol: BaseWireframeProtocol {
    //
}

// VIEW
protocol TweetViewDelegate: class {
    func notifyDidPostMessages(_ messages: [String])
}

protocol TweetViewProtocol: BaseViewProtocol {  // Conformed by View
    ///
    var presenter: TweetPresenterInputProtocol? { get set } // strong reference
    
    var delegate: TweetViewDelegate? { get set } // must be weak reference
}

// PRESENTER
protocol TweetPresenterInputProtocol: BasePresenterProtocol { // Conformed by Presenter
    ///
    var view: (TweetPresenterOutputProtocol & TweetViewProtocol)? { get set } // weak reference
    var wireframe: TweetWireframeProtocol? { get set } // strong reference
    var interactor: TweetInteractorInputProtocol? { get set } // strong reference
    
    func viewDidLoad()
    
    /// IBActions
    func didTapCloseButton()
    func didTapTweetButton(with text: String)
}

protocol TweetPresenterOutputProtocol { // Conformed by View
    func displayError(_ error: DisplayedError)
    func didPostMessages(_ messages: [String])
}

// INTERACTOR
protocol TweetInteractorInputProtocol: BaseInteractorProtocol { // Conformed by Interactor
    ///
    var presenter: TweetInteractorOutputProtocol?  { get set } // weak reference
}

protocol TweetInteractorOutputProtocol: class { // Conformed by Presenter
    //
}
