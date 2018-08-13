//
//  MessageTableViewCell.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

class MessageTableViewCell: UITableViewCell {
    static var IDENTIFIER: String {
        return "MessageTableViewCellID"
    }
    
    // Label to display message
    private let label: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 15)
        view.numberOfLines = 0
        view.lineBreakMode = NSLineBreakMode.byWordWrapping
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
        setUpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        backgroundColor = .white
        
        contentView.addSubview(label)
    }
    
    private func setUpLayout() {
        label.snp.remakeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with message: String?) {
        label.text = message
    }
    
    override func prepareForReuse() {
        label.text = ""
    }
}
