//
//  AddViewController.h
//  AddText
//
//  Created by Emanuel Azage on 3/21/16.
//  Copyright © 2016 Emanuel Azage. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionHandler)(NSString* textViewString, NSString* textFieldString);

@interface AddViewController : UIViewController

@property (nonatomic, copy) CompletionHandler completion;
@property (nonatomic, strong) NSString* labelString;
@property (strong, nonatomic) NSString* textFieldPlaceHolder;

@end

