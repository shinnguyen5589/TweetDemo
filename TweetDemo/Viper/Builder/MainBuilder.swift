//
//  MainBuilder.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

class MainBuilder: MainBuilderProtocol {
    func createMain() -> (UIViewController & MainViewProtocol) {
        let view = MainViewController()
        let presenter = MainPresenter()
        let interactor = MainInteractor()
        let wireframe = MainWireframe()
        
        view.presenter = presenter
        presenter.view = view 
        presenter.interactor = interactor
        presenter.wireframe = wireframe
        interactor.presenter = presenter
        
        return view
    }
}
