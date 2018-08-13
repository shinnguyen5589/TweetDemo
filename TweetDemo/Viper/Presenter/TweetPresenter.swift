//
//  TweetPresenter.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

class TweetPresenter: TweetPresenterInputProtocol {
    weak var view: (TweetPresenterOutputProtocol & TweetViewProtocol)?
    var wireframe: TweetWireframeProtocol?
    var interactor: TweetInteractorInputProtocol?
    
    func viewDidLoad() {
        //
    }
    
    private let messageSplitter: MessageSplittable
    
    init(messageSplitter: MessageSplittable) {
        self.messageSplitter = messageSplitter
    }
    
    private func dismissSelf() {
        if let view = self.view as? UIViewController {
            view.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func didTapCloseButton() {
        self.dismissSelf()
    }
    
    func didTapTweetButton(with text: String) {
        let result = messageSplitter.splitMessage(text)
        switch result {
        case .success(let chunks):
            self.view?.didPostMessages(chunks)
            self.dismissSelf()
        case .failure(let error):
            let displayedError = DisplayedError(from: error)
            self.view?.displayError(displayedError)
        }
    }
}

// MARK: - TweetInteractorOutputProtocol
extension TweetPresenter: TweetInteractorOutputProtocol {
    //
}
