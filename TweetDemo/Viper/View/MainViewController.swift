//
//  MainViewController.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

protocol MainViewControllerDelegate: class {
    func didTapTweetButton()
}

class MainViewController: BaseViewController, MainViewProtocol {
    
    var presenter: MainPresenterInputProtocol?
    
    // MARK: UI components
    private let _tableView: UITableView = {
        let view = UITableView()
        view.allowsSelection = false
        view.backgroundColor = .clear
        view.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        view.separatorColor = UIColor.lightGray
        view.estimatedRowHeight = 40
        view.rowHeight = UITableViewAutomaticDimension
        view.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.CELL_IDENTIFIER)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
    
    override func setupViews() {
        self.view.backgroundColor = UIColor.white
        
        self._tableView.dataSource = self
        self._tableView.delegate = self
        self.view.addSubview(self._tableView)
    }
    
    override func setupLayout() {
        self._tableView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func setUpNavigationBar() {
        // Title
        self.navigationItem.title = "Home"
        
        // Right bar button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"iconTweet"), style: .plain, target: self, action: #selector(didTapTweetButton))
        
        // Left bar button
        let profileButton = UIButton()
        profileButton.setImage(UIImage(named: "img_profile_nophoto"), for: UIControlState.normal)
        profileButton.addTarget(self, action:#selector(didTapAvatarIcon), for: UIControlEvents.touchUpInside)
        profileButton.layer.cornerRadius = 16
        profileButton.contentMode = UIViewContentMode.scaleAspectFill
        profileButton.layer.masksToBounds = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileButton)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: Events
    @objc func didTapTweetButton() {
        self.presenter?.didTapTweetButton()
    }
    
    @objc func didTapAvatarIcon() {
        self.presenter?.didTapAvatarIcon()
    }
}

extension MainViewController: MainPresenterOutputProtocol {
    func reload() {
        self._tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.numberOfItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.CELL_IDENTIFIER, for: indexPath) as? MessageTableViewCell else { return UITableViewCell() }
        
        let index = indexPath.row
        let item = self.presenter?.getItem(atIndex: index)
        cell.configure(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 60.0
    }
}

extension MainViewController: UITableViewDelegate {
    // TODO: -
}

extension MainViewController: TweetViewDelegate {
    func notifyDidPostMessages(_ messages: [String]) {
        self.presenter?.insertMessages(messages)
    }
}
