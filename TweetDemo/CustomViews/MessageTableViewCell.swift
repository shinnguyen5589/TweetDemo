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
    private let _label: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = UIFont.systemFont(ofSize: 15)
        view.numberOfLines = 0
        view.lineBreakMode = NSLineBreakMode.byWordWrapping
        return view
    }()
    
    override func setupViews() {
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(self._label)
    }
    
    override func setupLayout() {
        self._label.snp.remakeConstraints { (make) in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
        }
    }
    
    func configure(with message: String?) {
        self._label.text = message
    }
    
    override func prepareForReuse() {
        self._label.text = ""
    }
}
