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
    
    func viewDidLoad() {
        //
    }
    
    private(set) var messages = [String]()
    
    open var numberOfItems: Int {
        return messages.count
    }
    
    open func attachView(_ view: MainPresenterOutputProtocol & MainViewProtocol) {
        self.view = view
    }
    
    open func getItem(atIndex index: Int) -> String? {
        if index < numberOfItems {
            return messages[index]
        }
        
        return nil
    }
    
    // To call once receive didPostMessages from coordinator
    open func appendMessages(_ items: [String]) {
        // Do nothing when appending an empty array
        if items.count == 0 {
            return
        }
        
        // Append to list of messages and reload view
        messages.append(contentsOf: items)
        
        // Reload view on the main queue
        DispatchQueue.main.async {
            self.view?.reload()
        }
    }
    
    func didTapTweetButton() {
        if let view = self.view {
            self.wireframe?.showTweetView(from: view)
        }
    }
}

extension MainPresenter: MainInteractorOutputProtocol {
    //
}
