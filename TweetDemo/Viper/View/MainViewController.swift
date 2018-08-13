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

class MainViewController: UIViewController, MainViewProtocol {
    
    var presenter: MainPresenterInputProtocol?
    
    // MARK: UI components
    private let tableView: UITableView = {
        let view = UITableView()
        view.allowsSelection = false
        view.backgroundColor = .clear
        view.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        view.separatorColor = UIColor.lightGray
        view.estimatedRowHeight = 40
        view.rowHeight = UITableViewAutomaticDimension
        view.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.IDENTIFIER)
        return view
    }()
    
    // MARK: Variables
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setUpView()
        setUpLayout()
        setUpNavigationBar()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setUpLayout() {
        tableView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpNavigationBar() {
        navigationItem.title = "Home"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"iconTweet"), style: .plain, target: self, action: #selector(tweetButtonTapped))
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: MainView protocol
    func reload() {
        tableView.reloadData()
    }
    
    @objc func tweetButtonTapped() {
        self.presenter?.didTapTweetButton()
    }
}

extension MainViewController: MainPresenterOutputProtocol {
    //
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter!.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.IDENTIFIER, for: indexPath) as! MessageTableViewCell
        
        let index = indexPath.row
        let item = presenter?.getItem(atIndex: index)
        cell.configure(with: item)
        
        return cell
    }
}

extension MainViewController: TweetViewDelegate {
    func notifyDidPostMessages(_ messages: [String]) {
        self.presenter?.appendMessages(messages)
    }
}
