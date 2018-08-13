//
//  BaseTableViewCell.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/14/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

open class BaseTableViewCell : UITableViewCell {
    
    open class var CELL_IDENTIFIER: String { return "" }
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
        self.setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// Setup init view component.
    func setupViews() {
        //
    }
    
    /// Setup Layout for view component
    func setupLayout() {
        //
    }
}
