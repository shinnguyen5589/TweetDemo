//
//  MessageSplitterTests.swift
//  TweetDemoTests
//
//  Created by Dung Nguyen Hoang on 8/14/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

import XCTest

@testable import TweetDemo
class MessageSplitterTests: XCTestCase {
    
    let maxChunkLength = 50
    var splitter: MessageSplitter!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        splitter = MessageSplitter(maxChunkLength: maxChunkLength)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInit_WithMaxChunkLength() {
        XCTAssertEqual(splitter.maxChunkLength, maxChunkLength)
    }
    
    func testSplit_MessageShorterThanLimit_ShouldSucceed() {
        let message = (1...maxChunkLength / 2).map({ _ in "a" }).joined()
        let result = splitter.splitMessage(message)
        switch result {
        case .success(let chunks):
            XCTAssertEqual(chunks, [message])
        case .failure(_):
            XCTAssertTrue(false, "Should split the message normally")
        }
    }
    
    func testSplit_MessageWithOneWordLongerThanLimit_ShouldFail() {
        let message = (1...maxChunkLength + 10).map({ _ in "a" }).joined()
        let result = splitter.splitMessage(message)
        switch result {
        case .success(_):
            XCTAssertTrue(false, "Should fail to split the message")
        case .failure(let error):
            XCTAssertTrue(error is MessageSplittingError)
            XCTAssertTrue((error as! MessageSplittingError) == .containsTooLongWord)
        }
    }
    
    func testSplit_MessageHasMoreThanOneWord_AtLeastOneLongerThanLimit_ShouldFail() {
        let message = (1...maxChunkLength + 10).map({ _ in "a" }).joined()
        let result = splitter.splitMessage("\(message) \(message)")
        switch result {
        case .success(_):
            XCTAssertTrue(false, "Should fail to split the message")
        case .failure(let error):
            XCTAssertTrue(error is MessageSplittingError)
            XCTAssertTrue((error as! MessageSplittingError) == .containsTooLongWord)
        }
    }
    
    func testSplit_MessageHasOneWordLongerThanLimitIfCombineWithIndicator_ShouldFail() {
        // Each word of the following message is shorter than max length
        // But when combining with the part indicator, the built chunk is longer
        let message = (1...maxChunkLength - 2).map({ _ in "a" }).joined()
        let result = splitter.splitMessage("\(message) \(message)")
        switch result {
        case .success(_):
            XCTAssertTrue(false, "Should fail to split the message")
        case .failure(let error):
            XCTAssertTrue(error is MessageSplittingError)
            XCTAssertTrue((error as! MessageSplittingError) == .containsTooLongWord)
        }
    }
    
    func testSplit_MessageHasMoreThanOneWord_ShouldSucceed() {
        let message = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let result = splitter.splitMessage(message)
        switch result {
        case .failure(_):
            XCTAssertTrue(false, "Should split the message normally")
        case .success(let chunks):
            XCTAssertTrue(chunks.count > 1, "Should split into more than 1 chunk")
            
            let count = chunks.count
            chunks.enumerated().forEach({ index, chunk in
                XCTAssertTrue(chunk.starts(with: "\(index + 1)/\(count)"), "Each chunk should start with the part indicator")
                XCTAssertTrue(chunk.count <= splitter.maxChunkLength, "Each chunk should shorter than maxChunkLength")
            })
        }
    }
    
    func testSplit_MessageVeryLong_ShouldSucceed() {
        let item = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let message = (0...1000).map { _ in item }.joined(separator: " ")
        let result = splitter.splitMessage(message)
        switch result {
        case .failure(_):
            XCTAssertTrue(false, "Should split the message normally")
        case .success(let chunks):
            XCTAssertTrue(chunks.count > 1, "Should split into more than 1 chunk")
            
            let count = chunks.count
            chunks.enumerated().forEach({ index, chunk in
                XCTAssertTrue(chunk.starts(with: "\(index + 1)/\(count)"), "Each chunk should start with the part indicator")
                XCTAssertTrue(chunk.count <= splitter.maxChunkLength, "Each chunk should shorter than maxChunkLength")
            })
        }
    }
    
    func testSplit_ChunkAsLongAsPossible() {
        let input = "Apart from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. To check word count, simply place your cursor into the text box above and start typing. You'll see the number of characters and words increase or decrease as you type, delete, and edit them. You can also copy and paste text from another program over into the online editor above. The Auto-Save feature will make sure you won't lose any changes while editing, even if you leave the site and come back later. Tip: Bookmark this page now."
        let expected = ["1/15 Apart from counting words and characters, our",
                        "2/15 online editor can help you to improve word",
                        "3/15 choice and writing style, and, optionally,",
                        "4/15 help you to detect grammar mistakes and",
                        "5/15 plagiarism. To check word count, simply place",
                        "6/15 your cursor into the text box above and start",
                        "7/15 typing. You\'ll see the number of characters",
                        "8/15 and words increase or decrease as you type,",
                        "9/15 delete, and edit them. You can also copy and",
                        "10/15 paste text from another program over into",
                        "11/15 the online editor above. The Auto-Save",
                        "12/15 feature will make sure you won\'t lose any",
                        "13/15 changes while editing, even if you leave the",
                        "14/15 site and come back later. Tip: Bookmark this",
                        "15/15 page now."]
        let result = splitter.splitMessage(input)
        switch result {
        case .failure(_):
            XCTFail()
        case .success(let chunks):
            print(chunks.map { $0.count })
            print(expected.map { $0.count })
            XCTAssertEqual(chunks, expected)
        }
    }
    
    func testSplit_ChunkAsDialog() {
        let message = "Apart ApartfromcountingwordsandcharactersUronlineedi from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism."
        let result = splitter.splitMessage(message)
        
        switch result {
        case .failure(_):
            XCTAssertTrue(false, "Should split the message normally")
        case .success(let chunks):
            if chunks.count == 6 {
                XCTAssert(chunks[0] == "1/6 Apart", "The splited message should be optimized with the limit length!")
                XCTAssert(chunks[1] == "2/6 ApartfromcountingwordsandcharactersUronlineedi", "The splited message should be optimized with the limit length!")
                XCTAssert(chunks[2] == "3/6 from counting words and characters, our online", "The splited message should be optimized with the limit length!")
                XCTAssert(chunks[3] == "4/6 editor can help you to improve word choice and", "The splited message should be optimized with the limit length!")
                XCTAssert(chunks[4] == "5/6 writing style, and, optionally, help you to", "The splited message should be optimized with the limit length!")
                XCTAssert(chunks[5] == "6/6 detect grammar mistakes and plagiarism.", "The splited message should be optimized with the limit length!")
            }
        }
    }
    
    func testSplit_VeryLongValidMessage() {
        let input = "Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism. Apart ApartfromcountingwordsandcharactersU from counting words and characters, our online editor can help you to improve word choice and writing style, and, optionally, help you to detect grammar mistakes and plagiarism."
        let result = splitter.splitMessage(input)
        switch result {
        case .failure(_):
            XCTFail()
        case .success(let chunks):
            for (index, chunk) in chunks.enumerated() {
                XCTAssert(chunk.contains("\(index + 1)/324"), "The trunk should begin with this indicator")
            }
        }
    }
}
