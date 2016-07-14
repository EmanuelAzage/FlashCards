//
//  AddViewController.m
//  AddText
//
//  Created by Emanuel Azage on 3/21/16.
//  Copyright © 2016 Emanuel Azage. All rights reserved.
//

#import "AddViewController.h"

@interface AddViewController () <UITextViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextView *addTextView;
@property (weak, nonatomic) IBOutlet UITextField *addTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarItem;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.infoLabel.text = self.labelString;
    self.addTextField.text = self.textFieldPlaceHolder;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.addTextField becomeFirstResponder];
}

// touchesBegin for textView textField to resign keyboard
- (void) touchesBegan: (NSSet *)touches
            withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.addTextField isFirstResponder] &&
        [touch view] != self.addTextField) {
        [self.addTextField resignFirstResponder];
    }
    
    if ([self.addTextView isFirstResponder] &&
        [touch view] != self.addTextView) {
        [self.addTextView resignFirstResponder];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)cancelTouched:(id)sender {
    if(self.completion){
        self.completion(nil,nil);
    } else {
    }
    
    self.addTextField = nil;
    self.addTextView = nil;
}

- (IBAction)saveTouched:(id)sender {
    if(self.completion){ // completions is nil when it shouldnt be.
        self.completion(self.addTextView.text, self.addTextField.text);
    }
    
    self.addTextField = nil;
    self.addTextView = nil;
}

-(void) enableSaveButtonForTextView: (NSString*) textViewString
                          textField: (NSString*) textFieldString{
    
    if(textViewString.length > 0 && textFieldString.length > 0){
        [self.saveBarItem setEnabled:YES];
    } else {
        [self.saveBarItem setEnabled:NO];
    }
    
}


-(BOOL) textView: (UITextView*) textView
                shouldChangeTextInRange:(NSRange)range
                        replacementText:(nonnull NSString *)text{
    NSString* changedString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    [self enableSaveButtonForTextView:changedString textField:self.addTextField.text];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{// return NO to not change text

    [self enableSaveButtonForTextView:self.addTextView.text textField:string];
    
    return YES;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
