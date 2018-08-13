//
//  TweetViewController.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

protocol TweetViewControllerDelegate: class {
    func didTapDismiss()
    func didPostMessages(_ messages: [String])
}

class TweetViewController: UIViewController, TweetViewProtocol {
    
    var presenter: TweetPresenterInputProtocol?
    weak var delegate: TweetViewDelegate?
    
    // MARK: UI Components
    private let textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        view.textAlignment = .left
        view.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        return view
    }()
    
    // MARK: Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpView()
        setUpLayout()
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        
        view.addSubview(textView)
    }
    
    private func setUpLayout() {
        textView.snp.remakeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    private func setUpNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"iconClose"), style: .plain, target: self, action: #selector(closeButtonTapped))
        
        let tweetButton = UIButton.createPrimaryButton(title: "Tweet")
        tweetButton.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        tweetButton.addTarget(self, action: #selector(tweetButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: TweetViewProtocol
    
    func displayError(_ error: DisplayedError) {
        self.displayAlert(title: error.title, message: error.message)
    }
    
    // MARK: Events
    @objc func closeButtonTapped() {
        self.presenter?.didTapCloseButton()
    }
    
    @objc func tweetButtonTapped() {
        self.presenter?.didTapTweetButton(with: textView.text)
    }
    
    func didPostMessages(_ messages: [String]) {
        self.delegate?.notifyDidPostMessages(messages)
    }
}

extension TweetViewController: TweetPresenterOutputProtocol {
    //
}
