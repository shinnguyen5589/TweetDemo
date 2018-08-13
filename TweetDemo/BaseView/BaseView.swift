//
//  BaseView.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/14/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

open class BaseView: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
        self.setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupViews() {
        //
    }
    
    open func setupLayout() {
        //
    }
}
