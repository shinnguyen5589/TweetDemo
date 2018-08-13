//
//  Result.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

// Generic enum to represent result of function emitting 2 types: success & failure
enum Result<T> {
    case success(T) // Success comes up with an object of T type
    case failure(Error) // Failure comes up with an error
}
