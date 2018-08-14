//
//  MessageTableViewCell.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

class MessageTableViewCell: BaseTableViewCell {
    
     override open class var CELL_IDENTIFIER: String { return "MessageTableViewCellID" }
    
    // Label to display message
    private let _messageLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 15)
        view.numberOfLines = 0
        view.lineBreakMode = NSLineBreakMode.byWordWrapping
        return view
    }()
    
    private let _totalCharsLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 12)
        view.numberOfLines = 0
        view.lineBreakMode = NSLineBreakMode.byWordWrapping
        return view
    }()
    
    override func setupViews() {
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(self._messageLabel)
        self.contentView.addSubview(self._totalCharsLabel)
    }
    
    override func setupLayout() {
        self._messageLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.lessThanOrEqualTo(self._totalCharsLabel.snp.leading).offset(-5)
            make.top.greaterThanOrEqualToSuperview().offset(2)
        }
        
        self._totalCharsLabel.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalToSuperview().dividedBy(10)
            make.top.greaterThanOrEqualToSuperview().offset(2)
        }
    }
    
    func configure(with message: String?) {
        self._messageLabel.text = message
        self._totalCharsLabel.text = "\(message?.count ?? 0)/\(MAX_TWEET_CHUNK_LENGTH)"
    }
    
    override func prepareForReuse() {
        self._messageLabel.text = ""
        self._totalCharsLabel.text = ""
    }
}
