//
//  DisplayedError.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

// Struct to display error message from view
struct DisplayedError {
    private(set) var title: String? = nil
    private(set) var message: String?
    
    private init(title: String? = nil, message: String? = nil) {
        self.title = title
        self.message = message
    }
    
    init(from error: Error) {
        if let error = error as? MessageSplittingError {
            self.init(from: error)
        } else {
            self.init(message: error.localizedDescription)
        }
    }
    
    private init(from splittingMessageError: MessageSplittingError) {
        self.title = "Oops..."
        
        switch splittingMessageError {
        case .emptyOrWhitespacesOnlyMessage:
            self.message = "Don't be shy bro! Share something with us <3"
        case .containsTooLongWord:
            self.message = "We know you're crazily excited but some word is too long :P\nCan you shorten it a bit?"
        }
    }
}
