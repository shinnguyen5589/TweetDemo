//
//  String+Extension.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

extension String {
    // Extension method to remove redundante whitespaces inside a string
    func removingRedundantWhitespaces() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter({ !$0.isEmpty }).joined(separator: " ")
    }
}
