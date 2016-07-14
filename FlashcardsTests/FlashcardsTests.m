//
//  FlashcardsTests.m
//  FlashcardsTests
//
//  Created by Emanuel Azage on 3/9/16.
//  Copyright © 2016 Emanuel Azage. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FlashCardModel.h"

@interface FlashcardsTests : XCTestCase
@property (strong, nonatomic) FlashCardModel* model;
@end

@implementation FlashcardsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _model = [[FlashCardModel alloc] init];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitial{
    XCTAssertEqual(6, [self.model numberOfFlashcards]);
}

- (void)testInsertQuestionAndAnswer{
    [self.model insertFlashcard:@"What do you get when you add 18 to 27?" answer:@"45"];
    [self.model insertFlashcard:@"What do you get when you add 18 to 27?" answer:@"45"];
    [self.model insertFlashcard:@"What do you get when you add 18 to 27?" answer:@"45"];
    [self.model insertFlashcard:@"What do you get when you add 18 to 27?" answer:@"45"];
    [self.model insertFlashcard:@"What do you get when you add 18 to 27?" answer:@"45"];
    
    XCTAssertEqual(11, [self.model numberOfFlashcards]);
}

-(void)testInsertFlashCard{
    NSDictionary* flashcard = [[NSDictionary alloc] initWithObjectsAndKeys:@"What is 13 + 45?", kQuestionKey, @"58", kAnswerKey, nil];
    [self.model insertFlashcard:flashcard];
    
    flashcard = [[NSDictionary alloc] initWithObjectsAndKeys:@"What is 13 + 40?", kQuestionKey, @"53", kAnswerKey, nil];
    [self.model insertFlashcard:flashcard];
    
    XCTAssertEqual(8, [self.model numberOfFlashcards]);
    XCTAssertEqualObjects(flashcard, [self.model flashcardAtIndex:self.model.numberOfFlashcards-1]);
}

-(void)testInsertAtIndex{
    NSDictionary* flashcard = [[NSDictionary alloc] initWithObjectsAndKeys:@"What is 13 + 45?", kQuestionKey, @"58", kAnswerKey, nil];
    [self.model insertFlashcard:flashcard atIndex:3];
    
    XCTAssertEqual(7, [self.model numberOfFlashcards]);
    XCTAssertEqualObjects(flashcard, [self.model flashcardAtIndex:3]);
}

-(void)testInsertWithAnswerAtIndex{
    [self.model insertFlashcard:@"What do you get when you add 18 to 27?" answer:@"45" atIndex:4];
    XCTAssertEqual(7, [self.model numberOfFlashcards]);
}

-(void)testRemove{
    [self.model removeFlashcardAtIndex:0];
    XCTAssertEqual(5, [self.model numberOfFlashcards]);
}

-(void)testOutOfBoundsInsert{
    // should insert since its out of bounds
    [self.model insertFlashcard:@"What do you get when you add 18 to 27?" answer:@"45" atIndex:self.model.numberOfFlashcards+1];
    XCTAssertEqual(6, self.model.numberOfFlashcards);
}

//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
