//
//  FlashCardModel.m
//  Flashcards
//
//  Created by Emanuel Azage on 3/9/16.
//  Copyright © 2016 Emanuel Azage. All rights reserved.
//

#import "FlashCardModel.h"

// class extension
@interface FlashCardModel ()

// private properties
@property (strong, nonatomic) NSMutableArray *flashcards;
@property (nonatomic) NSUInteger currentCard;
@property (strong, nonatomic) NSString* filePath;
@end

@implementation FlashCardModel

+(instancetype) sharedModel{
    static FlashCardModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // code to be executed once - thread safe version
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        _filePath = [documentsDirectory stringByAppendingPathComponent:kFlashcardsPList];
        _flashcards = [NSMutableArray arrayWithContentsOfFile:_filePath];
        
        if(!_flashcards){
            NSArray* storedFlashcards = [[NSUserDefaults standardUserDefaults] objectForKey: kFlashcardsArrayKey];
            
            if(storedFlashcards){
                _flashcards = [storedFlashcards mutableCopy];
            } else {
                // initialize our properties
                NSDictionary *card1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"What is 5 + 11?", kQuestionKey, @"16", kAnswerKey, nil];
                NSDictionary *card2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"What do you get when you add 7 to 12?", kQuestionKey, @"19", kAnswerKey, nil];
                NSDictionary *card3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"What is 12 + 17?", kQuestionKey, @"29", kAnswerKey, nil];
                NSDictionary *card4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"10 + 31?", kQuestionKey,
                                       @"41", kAnswerKey, nil];
                NSDictionary *card5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Makeda has 7 dollars, and Redi has 5 dollars, how much do they have together?", kQuestionKey,
                                       @"12", kAnswerKey, nil];
                NSDictionary *card6 = [[NSDictionary alloc] initWithObjectsAndKeys:@"What do you get when you add 18 to 27?", kQuestionKey, @"45", kAnswerKey, nil];
                //        NSDictionary *card7 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Hate, it has caused a lot of problems in the world, but has not solved one yet.", kQuestionKey,
                //                                @"Maya Angelou", kAnswerKey, nil];
                //        NSDictionary *card8 = [[NSDictionary alloc] initWithObjectsAndKeys:@"It takes a great deal of bravery to stand up to our enemies, but just as much to stand up to our friends.", kQuestionKey,
                //                                @"J. K. Rowling", kAnswerKey, nil];
                
                _flashcards = [[NSMutableArray alloc] initWithObjects:
                               card1, card2, card3, card4, card5, card6, nil];
            }
        }
        _currentCard = 0;
        
        // file path for plist, delete later.
//        NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager]
//                                            URLsForDirectory:NSDocumentDirectory
//                                            inDomains:NSUserDomainMask] lastObject]);
    }
    return self;
}

- (NSUInteger) numberOfFlashcards {
    return [self.flashcards count];
}

- (NSDictionary *) randomFlashcard {
    if(self.numberOfFlashcards == 0){
        return [self emptyCard]; // return the card with the add a question, answer text
    }
    
    NSUInteger index  = arc4random_uniform( (int)[self numberOfFlashcards] );
    while (index == self.currentCard) { // so we don't go to the same number we were at before. Very unlikely this iterates more than 2 or 3 times
        index = arc4random_uniform( (int)[self numberOfFlashcards] );
    }
    NSDictionary *card = self.flashcards[index];
    self.currentCard = index;
    return card;
}

-(NSDictionary*) flashcardAtIndex:(NSUInteger)index{
    NSDictionary* card = nil;
    if(self.numberOfFlashcards == 0){
        // return the card with the add a question, answer text
    } else if(index < self.numberOfFlashcards){
        card = self.flashcards[index];
    }
    return card;
}

- (void) removeFlashcardAtIndex: (NSUInteger) index{
    if (index < self.numberOfFlashcards) {
        [self.flashcards removeObjectAtIndex:index];
    }
    [self save];
}

- (void) insertFlashcard: (NSDictionary *) flashcard{
    [self.flashcards addObject:flashcard];
    [self save];
}

- (void) insertFlashcard: (NSString *) question
                  answer: (NSString *) answer{
    NSDictionary* card = [[NSDictionary alloc] initWithObjectsAndKeys:question, kQuestionKey, answer, kAnswerKey, nil];
    [self insertFlashcard:card];
    [self save];
}

// doesn't insert anything if it is out of bounds
- (void) insertFlashcard: (NSDictionary *) flashcard
                 atIndex: (NSUInteger) index{
    
    if(index < self.numberOfFlashcards){
        [self.flashcards insertObject:flashcard atIndex:index];
    }
    [self save];
}

- (void) insertFlashcard: (NSString *) flashcard
                  answer: (NSString *) answer
                 atIndex: (NSUInteger) index{
    
    NSDictionary* card = [[NSDictionary alloc] initWithObjectsAndKeys:flashcard, kQuestionKey, answer, kAnswerKey, nil];
    
    [self insertFlashcard:card atIndex:index];
    [self save];
}

- (NSDictionary *) nextFlashcard{
    if(self.numberOfFlashcards == 0){
        return [self emptyCard]; // return the card with the add a question, answer text
    }
    
    [self incrementCurrentCard];
    NSDictionary* nextCard = self.flashcards[self.currentCard];
    return nextCard;
}

- (NSDictionary *) prevFlashcard{
    if(self.numberOfFlashcards == 0){
        return [self emptyCard]; // return the card with the add a question, answer text
    }
    [self decrementCurrentCard];
    NSDictionary* prevCard = self.flashcards[self.currentCard];
    return prevCard;
}

-(void) incrementCurrentCard{
    if(self.currentCard == self.numberOfFlashcards - 1){
        [self setCurrentCard:0];
    } else{
        _currentCard++;
    }
}

-(void) decrementCurrentCard{
    if(self.currentCard == 0){
        [self setCurrentCard: self.numberOfFlashcards - 1];
    } else{
        _currentCard--;
    }
}

-(void) save {
    [self.flashcards writeToFile:self.filePath atomically:YES];
}

-(NSDictionary*) emptyCard{
    return [[NSDictionary alloc] initWithObjectsAndKeys:@"Please add a Question.", kQuestionKey,
            @"Please add an Answer.", kAnswerKey, nil]; // return the card with the add a question, answer text
}

@end
