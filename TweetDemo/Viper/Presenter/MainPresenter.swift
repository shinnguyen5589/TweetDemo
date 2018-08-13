//
//  MainPresenter.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

class MainPresenter: MainPresenterInputProtocol {
    weak var view: (MainPresenterOutputProtocol & MainViewProtocol)?
    var wireframe: MainWireframeProtocol?
    var interactor: MainInteractorInputProtocol?
    
    private(set) var messages = [String]()
    
    func viewDidLoad() {
        //
    }
    
    // MARK: MainPresenterInputProtocol
    var numberOfItems: Int {
        return self.messages.count
    }
    
    func getItem(atIndex index: Int) -> String? {
        if index < self.numberOfItems {
            return self.messages[index]
        }
        
        return nil
    }
    
    func insertMessages(_ items: [String]) {
        // Do nothing when appending an empty array
        if items.count == 0 {
            return
        }
        
        // Insert to list of messages and reload view
        self.messages.insert(contentsOf: items, at: 0)
        
        // Reload view on the main queue
        DispatchQueue.main.async {
            self.view?.reload()
        }
    }
    
    /// IBActions
    func didTapTweetButton() {
        if let view = self.view {
            self.wireframe?.showTweetView(from: view)
        }
    }
    
    func didTapAvatarIcon() {
        // TODO: -
    }
}

extension MainPresenter: MainInteractorOutputProtocol {
    //
}
