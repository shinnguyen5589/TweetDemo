//
//  MessageSplitter.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

private extension Int {
    // Return number of digits
    var numberOfDigits: Int {
        return String(self).count
    }
}

typealias MessageSplittingResult = Result<[String]>

// In case we have another requirement for the message splitter
// Just conform the following protocol and update the logic of splitMessage function
protocol MessageSplittable {
    var maxChunkLength: Int { get }
    func splitMessage(_ message: String) -> MessageSplittingResult
}

// Enum to indicate error type when splitting message
enum MessageSplittingError: Error {
    case emptyOrWhitespacesOnlyMessage
    case containsTooLongWord
}

class MessageSplitter: MessageSplittable {
    private(set) var maxChunkLength: Int
    
    init(maxChunkLength: Int) {
        self.maxChunkLength = maxChunkLength
    }
    
    func splitMessage(_ message: String) -> MessageSplittingResult {
        // Before we start, make sure the message is polished by trimming spaces in the first and last
        let actualMessage = message.trim()
        let length = actualMessage.count
        
        // The message is empty after polishing, return an error
        if length == 0 {
            return .failure(MessageSplittingError.emptyOrWhitespacesOnlyMessage)
        }
        
        // We do not need to split if the message is shorter than max length
        if length <= self.maxChunkLength {
            return .success([actualMessage])
        }
        
        // Start to split
        var chunks = [String]()
        
        // Before splitting message, we should estimate chunk count first
        // Dont forget to include part indicator length while estimating
        var totalMessages: Int = Int(ceil(Double(actualMessage.count) / Double(self.maxChunkLength)))
        var indicatorLength: Int = totalMessages.numberOfDigits
        let words = actualMessage.split(separator: " ")
        
        // Start to calculate
        var realTotalMessages: Int = 0
        var isValidMessage: Bool = false
        
        // Loop to find valid indicatorLength.
        // Ex: 1/50 --> 1 is message index and 50 is indicator length
        while isValidMessage == false {
            // Compute first trunk
            var messageIndex: Int = 1
            var messageLength: Int = String(messageIndex).count + 1 + indicatorLength + 1 + words[0].count
            if messageLength > self.maxChunkLength {
                return .failure(MessageSplittingError.containsTooLongWord)
            }
            
            var shouldBreakWhileLoop: Bool = false
            realTotalMessages = 1
            
            // Loop to the last word in message
            for (index, word) in words.enumerated() {
                if word.count >= self.maxChunkLength {
                    realTotalMessages = 0
                    indicatorLength = 0
                    shouldBreakWhileLoop = true
                    // The message contains too long word
                    return .failure(MessageSplittingError.containsTooLongWord)
                }
                
                // Compute the next trunks
                if index > 0 {
                    if messageLength + 1 + word.count <= self.maxChunkLength {
                        // We still compute this trunk, go to next word
                        messageLength = messageLength + 1 + word.count
                    } else {
                        messageLength = String(messageIndex).count + 1 + indicatorLength + 1 + word.count
                        
                        if messageLength > self.maxChunkLength {
                            realTotalMessages = 0
                            indicatorLength = 0
                            shouldBreakWhileLoop = true
                            // The message contains too long word
                            return .failure(MessageSplittingError.containsTooLongWord)
                        }
                        
                        // We finish one sentence, start to compute new sentence
                        messageIndex = messageIndex + 1
                        realTotalMessages = realTotalMessages + 1
                    }
                }
            }
            
            // Can not split, break and return fail
            if shouldBreakWhileLoop == true {
                break
            }
            
            // Validate realTotalMessages with indicatorLength, start the validation process if the number of realTotalMessages is not valid
            if realTotalMessages > 0 && String(realTotalMessages).count == indicatorLength {
                isValidMessage = true
            } else {
                // Continue to loop to find the valid indicatorLength
                totalMessages = totalMessages * 10
                indicatorLength = indicatorLength + 1
                realTotalMessages = 0
                chunks.removeAll()
            }
        }
        
        // Split success, compute and print the output trunks
        if isValidMessage == true {
            var messageIndex: Int = 1
            chunks.append("\(messageIndex)/\(realTotalMessages)")
            
            for (_, word) in words.enumerated() {
                if chunks[chunks.count - 1].count + 1 + word.count <= self.maxChunkLength {
                    let newMessage: String = "\(chunks[chunks.count - 1]) \(word)"
                    chunks[chunks.count - 1] = newMessage
                } else {
                    messageIndex = messageIndex + 1
                    let newMessage: String = "\(messageIndex)/\(realTotalMessages) \(word)"
                    chunks.append(newMessage)
                }
            }
        }
        
        return .success(chunks)
    }
}
