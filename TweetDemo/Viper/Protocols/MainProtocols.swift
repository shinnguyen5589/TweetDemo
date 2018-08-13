//
//  MainProtocols.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

// BUILDER
protocol MainBuilderProtocol: BaseBuilderProtocol {
    //
}

// WIREFRAME
protocol MainWireframeProtocol: BaseWireframeProtocol {
    func showTweetView(from view: MainViewProtocol)
}

// VIEW
protocol MainViewProtocol: BaseViewProtocol {  // Conformed by View
    ///
    var presenter: MainPresenterInputProtocol? { get set } // strong reference
}

// PRESENTER
protocol MainPresenterInputProtocol: BasePresenterProtocol { // Conformed by Presenter
    ///
    var view: (MainPresenterOutputProtocol & MainViewProtocol)? { get set } // weak reference
    var wireframe: MainWireframeProtocol? { get set } // strong reference
    var interactor: MainInteractorInputProtocol? { get set } // strong reference
    
    func viewDidLoad()
    
    var numberOfItems: Int { get }
    func getItem(atIndex index: Int) -> String?
    func insertMessages(_ items: [String])
    
    /// IBActions
    func didTapTweetButton()
    func didTapAvatarIcon()
}

protocol MainPresenterOutputProtocol { // Conformed by View
    func reload()
}

// INTERACTOR
protocol MainInteractorInputProtocol: BaseInteractorProtocol { // Conformed by Interactor
    ///
    var presenter: MainInteractorOutputProtocol?  { get set } // weak reference
}

protocol MainInteractorOutputProtocol: class { // Conformed by Presenter
    //
}
