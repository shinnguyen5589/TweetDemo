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
    
    private func numberOfIndicatorCharacters(forChunkCount chunkCount: Int) -> Int {
        var copyOfChunkCount = chunkCount
        
        // A chunk's part indicator has 2 parts:
        // Left part contains numerical order of chunk & "/"
        // Right part contains chunk count & a whitespace in front of chunk's content
        var leftPartCharacters = 0
        while copyOfChunkCount > 0 {
            // For example, chunk count is 999 -> we have to count number of characters representing left part of indicator
            // from 100 -> 999, then 10 -> 99, then 1 -> 9
            let n = copyOfChunkCount.numberOfDigits
            let start = Int(pow(10.0, Double(n - 1)))
            leftPartCharacters += (copyOfChunkCount - start + 1) * (start.numberOfDigits + 1)
            
            copyOfChunkCount = start - 1
        }
        
        let rightPartCharacters = chunkCount * (chunkCount.numberOfDigits + 1)
        let characters = leftPartCharacters + rightPartCharacters
        return characters
    }
    
    func splitMessage(_ message: String) -> MessageSplittingResult {
        // Before we start, make sure the message is polished by removing redundante whitespaces
        let actualMessage = message.removingRedundantWhitespaces()
        let length = actualMessage.count
        
        // The message is empty after polishing, return an error
        if length == 0 {
            return .failure(MessageSplittingError.emptyOrWhitespacesOnlyMessage)
        }
        
        // We don't need to split if the message is shorter than max length
        if length <= self.maxChunkLength {
            return .success([actualMessage])
        }
        
        // Before splitting message, we should estimate chunk count first
        // Dont forget to include part indicator length while estimating
        var estimatedChunkCount = length / maxChunkLength + 1
        let indicatorLength = numberOfIndicatorCharacters(forChunkCount: estimatedChunkCount)
        estimatedChunkCount = (length + indicatorLength) / maxChunkLength + 1
        
        // Well, let's split the message as requirement
        var chunks = [String]()
        let words = actualMessage.split(separator: " ").map({ String($0) })
        var i = 0
        var currentChunk = ""
        let wordCount = words.count
        var index = 1
        while i < wordCount {
            let word = words[i]
            // If any word in the message is combined with the part indicator to be a chunk is longer than max length, return an error
            // Content of chunk is built following the format: "[index of chunk]/[chunk count] [content]"
            if word.count + index.numberOfDigits + estimatedChunkCount.numberOfDigits + 2 > maxChunkLength {
                return .failure(MessageSplittingError.containsTooLongWord)
            }
            
            // We'll try to build a valid chunk by joining every word until chunk's length exceeds the limit
            var currentChunkToWord: String = ""
            if currentChunk.isEmpty {
                currentChunkToWord = currentChunk.appending(word)
            } else {
                currentChunkToWord = currentChunk.appending(" \(word)")
            }
            
            // To reviewer: I'm not really sure about that :|
            // We want to put as many words as possible so let's remove the 1-character reservation here
            let chunkLength = currentChunkToWord.count + index.numberOfDigits + estimatedChunkCount.numberOfDigits + 2
            if chunkLength > maxChunkLength {
                // The considered chunk is longer than the limit, should pick until the previous word
                chunks.append("\(index)/%d \(currentChunk)")
                currentChunk = ""
                index += 1
                continue
            } else if chunkLength == maxChunkLength || i == wordCount - 1 {
                // The consider chunk equals the limit or we get to the last word, pick it anyway
                chunks.append("\(index)/%d \(currentChunkToWord)")
                currentChunk = ""
                index += 1
            } else {
                // It isn't long enough for a chunk to be splitted
                if currentChunk.isEmpty {
                    currentChunk = word
                } else {
                    currentChunk += " \(word)"
                }
            }
            
            i += 1
        }
        
        // Let's do the final step, put the chunk count to each chunk
        let chunkCount = chunks.count
        chunks.enumerated().forEach { (index, chunk) in
            chunks[index] = String(format: chunk, chunkCount)
        }
        
        return .success(chunks)
    }
}
