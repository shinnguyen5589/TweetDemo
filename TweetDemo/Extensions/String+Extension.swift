//
//  String+Extension.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

extension String {
    public func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
