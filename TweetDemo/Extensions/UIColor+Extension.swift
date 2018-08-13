//
//  UIColor+Extension.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/14/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
