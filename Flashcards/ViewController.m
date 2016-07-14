//
//  ViewController.m
//  Flashcards
//
//  Created by Emanuel Azage on 3/9/16.
//  Copyright © 2016 Emanuel Azage. All rights reserved.
//

#import "ViewController.h"
#import "FlashCardModel.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *answerQuestionLabel;
@property (strong, nonatomic) FlashCardModel* model;
@property (strong, nonatomic) NSDictionary* currentCard;
@property (strong, nonatomic) UIColor* answerColor;
@property (strong, nonatomic) UIColor* questionColor;
@property (weak, nonatomic) IBOutlet UIImageView* backgroundImageView;
@property (strong, nonatomic) AVAudioPlayer* toneAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer* tadaAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer* fadeinAudioPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _questionColor = [UIColor colorWithRed:.05 green:.95 blue:.63 alpha:1];// bluish green
    _answerColor = [UIColor colorWithRed:.88 green:.4 blue:.4 alpha:1];// light red, salmon
    
    self.answerQuestionLabel.textColor = self.questionColor;
    
    self.model = [FlashCardModel sharedModel];
    [self setCurrentCard: [self.model flashcardAtIndex:0]];
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(singleTapped:)];
    [self.view addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(doubleTapped:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    UISwipeGestureRecognizer* swipeLeft = [ [UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer* swipeRight = [ [UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    
    _toneAudioPlayer = [self createAudioPlayerWithSound:@"tone.mp3"];
    [self.toneAudioPlayer prepareToPlay];
    
    _tadaAudioPlayer = [self createAudioPlayerWithSound:@"TaDa.wav"];
    [self.tadaAudioPlayer prepareToPlay];
    
    _fadeinAudioPlayer = [self createAudioPlayerWithSound:@"fadein.wav"];
    [self.fadeinAudioPlayer prepareToPlay];
}

-(BOOL) canBecomeFirstResponder{
    return  YES;
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

// when shaked, display a random card
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (motion == UIEventSubtypeMotionShake) {
        [self.toneAudioPlayer play];
        //animate fade out
        [self fadeOutAll];
        [self displayRandCard];
        //animate fade in
        [self fadeInAll];
    }
}

// display the answer of the current card
- (void) singleTapped: (UITapGestureRecognizer*) tr {
    [self.tadaAudioPlayer play];
    [self fadeOutLabel]; //animate fade out
    self.answerQuestionLabel.textColor = self.answerColor; // change color of answer
    self.answerQuestionLabel.text = self.currentCard[kAnswerKey];
    [self fadeInLabel];//animate fade in
}

// display the question of a random card
- (void) doubleTapped: (UITapGestureRecognizer*) tr {
    //animate fade out
    [self fadeOutLabel];
    [self displayRandCard];
    //animate fade in
    [self fadeInLabel];
}

//display the question of the next card
-(void) swipedLeft: (UISwipeGestureRecognizer* ) sr {
    [self.fadeinAudioPlayer play];
    //animate fade out
    [self fadeOutAll];
    self.answerQuestionLabel.textColor = self.questionColor; // change color for question
    self.currentCard = [self.model nextFlashcard];
    self.answerQuestionLabel.text = self.currentCard[kQuestionKey];
    //animate fade in
    [self fadeInAll];
}

//display the question of the previous card
-(void) swipedRight: (UISwipeGestureRecognizer* ) sr {
    [self.fadeinAudioPlayer play];
    //animate fade out
    [self fadeOutAll];
    self.answerQuestionLabel.textColor = self.questionColor; // change color for question
    self.currentCard = [self.model prevFlashcard];
    self.answerQuestionLabel.text = self.currentCard[kQuestionKey];
    //animate fade in
    [self fadeInAll];
}

- (void) displayRandCard{
    self.answerQuestionLabel.textColor = self.questionColor; // change color for question
    self.currentCard = self.model.randomFlashcard;
    self.answerQuestionLabel.text = self.currentCard[kQuestionKey];
}

- (AVAudioPlayer*) createAudioPlayerWithSound: (NSString*) soundFile{
    
    NSString* soundPath = [NSString stringWithFormat:@"%@/%@", [ [NSBundle mainBundle] resourcePath], soundFile];
    NSURL* soundURL = [NSURL fileURLWithPath:soundPath];
    
    NSError* error;
    return [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
}

//                      ******* animations ********

- (void) fadeInLabel{
    [UIView animateWithDuration:1.0 animations:^{
        self.answerQuestionLabel.alpha = 1;
    }];
}

-(void) fadeOutLabel{
    [UIView animateWithDuration:1.0 animations:^{
        self.answerQuestionLabel.alpha = 0;
    }];
}

- (void) fadeInAll{
    [UIView animateWithDuration:1.0 animations:^{
        self.backgroundImageView.alpha = 1;
        self.answerQuestionLabel.alpha = 1;
    }];
}

-(void) fadeOutAll{
    [UIView animateWithDuration:1.0 animations:^{
        self.backgroundImageView.alpha = 0;
        self.answerQuestionLabel.alpha = 0;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
