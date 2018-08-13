//
//  UIButton+Extensions.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

extension UIButton {
    // Static func to create a button as Tweeter's style
    static func createPrimaryButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(red: 33.0 / 255.0, green: 150.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        button.setTitleColor(.white, for: .normal)
        
        button.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .disabled)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.3), for: .highlighted)
        
        return button
    }
}
