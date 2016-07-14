//
//  TableViewController.m
//  TableViewPractice
//
//  Created by Emanuel Azage on 3/7/16.
//  Copyright © 2016 Emanuel Azage. All rights reserved.
//

#import "TableViewController.h"
#import "FlashCardModel.h"
#import "addViewController.h"

@interface TableViewController ()
@property (strong, nonatomic) FlashCardModel* model;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [FlashCardModel sharedModel];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.numberOfFlashcards;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    
    //Configure the cell...
    NSDictionary* quote = [self.model flashcardAtIndex: indexPath.row];
    
    cell.textLabel.text = quote[kAnswerKey];
    cell.detailTextLabel.text = quote[kQuestionKey];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.model removeFlashcardAtIndex: indexPath.row]; // update model first
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation
//- (IBAction)addQuote:(id)sender {
//     [self performSegueWithIdentifier:@"addSegue" sender:sender];
//}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqual:@"addSegue"]){
        
        AddViewController* addVC = [segue destinationViewController];
        
        // set public properties
        addVC.labelString = @"Please enter a Question and Answer";
        addVC.textFieldPlaceHolder = @"";
        
//        addVC.completion = ^(NSString* textViewString, NSString* textFieldString){
//            
//            if(textViewString != nil){ // save was touched
//                [self.model insertQuote:textViewString author:textFieldString]; // insert into model
//                [self.tableView reloadData];// update table view
//            }
//            
//            [self dismissViewControllerAnimated:YES completion:nil];
//            
//        };
        
        [addVC setCompletion:^(NSString* textViewString, NSString* textFieldString){
            
            if(textViewString != nil){ // save was touched
                [self.model insertFlashcard:textViewString answer:textFieldString]; // insert into model
                [self.tableView reloadData];// update table view
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }
}

@end
