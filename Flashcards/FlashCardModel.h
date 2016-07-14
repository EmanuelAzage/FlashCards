//
//  FlashCardModel.h
//  Flashcards
//
//  Created by Emanuel Azage on 3/9/16.
//  Copyright © 2016 Emanuel Azage. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kQuestionKey = @"question";
static NSString * const kAnswerKey = @"answer";
static NSString * const kFlashcardsArrayKey = @"FlashcardArrayKey";
static NSString* const kFlashcardsPList = @"Flashcards.plist";

@interface FlashCardModel : NSObject
+ (instancetype) sharedModel;
- (NSDictionary *) randomFlashcard;
- (NSUInteger) numberOfFlashcards;
- (NSDictionary *) flashcardAtIndex: (NSUInteger) index;
- (void) removeFlashcardAtIndex: (NSUInteger) index;
- (void) insertFlashcard: (NSDictionary *) flashcard;
- (void) insertFlashcard: (NSString *) question
                  answer: (NSString *) answer;
- (void) insertFlashcard: (NSDictionary *) flashcard
                 atIndex: (NSUInteger) index;
- (void) insertFlashcard: (NSString *) flashcard answer: (NSString *) answer
                 atIndex: (NSUInteger) index;
- (NSDictionary *) nextFlashcard;
- (NSDictionary *) prevFlashcard;
@end
