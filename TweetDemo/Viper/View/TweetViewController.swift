//
//  TweetViewController.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

// MARK: TweetViewControllerDelegate
protocol TweetViewControllerDelegate: class {
    func didPostMessages(_ messages: [String])
}

// MARK: TweetViewController
class TweetViewController: BaseViewController, TweetViewProtocol {
    
    var presenter: TweetPresenterInputProtocol?
    weak var delegate: TweetViewDelegate?
    
    // MARK: UI Components
    private var _placeholderLabel : UILabel = {
        let view = UILabel()
        view.text = "What's happening?"
        view.font = UIFont.italicSystemFont(ofSize: 15)
        view.sizeToFit()
        return view
    }()
    
    private let _textView: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        view.textAlignment = .left
        view.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self._textView.becomeFirstResponder()
    }
    
    override func setupViews() {
        self.view.backgroundColor = UIColor.white
        
        self._textView.delegate = self
        self._textView.addSubview(self._placeholderLabel)
        self._placeholderLabel.frame.origin = CGPoint(x: 15, y: (self._textView.font?.pointSize)! / 2)
        self._placeholderLabel.textColor = UIColor.lightGray
        self._placeholderLabel.isHidden = !self._textView.text.isEmpty
        self.view.addSubview(self._textView)
    }
    
    override func setupLayout() {
        self._textView.snp.remakeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(300)
        }
    }
    
    override func setUpNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"iconClose"), style: .plain, target: self, action: #selector(didTapCloseButton))
        
        let tweetButton = UIButton.createPrimaryButton(title: "Tweet")
        tweetButton.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        tweetButton.addTarget(self, action: #selector(didTapTweetButton), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
   
    // MARK: Events
    @objc func didTapCloseButton() {
        self.presenter?.didTapCloseButton()
    }
    
    @objc func didTapTweetButton() {
        self.presenter?.didTapTweetButton(with: self._textView.text)
    }
}

// MARK: TweetPresenterOutputProtocol
extension TweetViewController: TweetPresenterOutputProtocol {
    func didPostMessages(_ messages: [String]) {
        self.delegate?.notifyDidPostMessages(messages)
    }
    
    func displayError(_ error: DisplayedError) {
        self.displayAlert(title: error.title, message: error.message)
    }
}

// MARK: UITextViewDelegate
extension TweetViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self._placeholderLabel.isHidden = !textView.text.isEmpty
    }
}
