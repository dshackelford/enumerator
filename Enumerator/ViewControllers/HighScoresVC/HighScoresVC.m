//
//  HighScoresVC.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/13/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HighScoresVC.h"

@implementation HighScoresVC

-(void)viewDidLoad
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetData:) name:nDidGetData object:nil];
    
    [super viewDidLoad];
//    screenSize = [UIScreen mainScreen].bounds.size;
    self.title = @"High Scores";
    backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    self.navigationItem.leftBarButtonItem.title = @"Done";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    tableData = @[@"Personal High Scores"];
    //,@"Global High Scores"
}



#pragma mark - Table View Delegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //need to figure out how many scores in this section, not some static number
    return [tableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0; // you can have your own choice, of course
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator]; //the grey chevron    
    return cell;
}

#pragma mark - Cell Selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.selectedRow = (int)indexPath.row;
    
    //subsettings with Segmented Control
    if(self.selectedRow == 0)
    {
        //show day Segmented Control
        [self performSegueWithIdentifier:@"showUserHighScoresVC" sender:self];
    }
    else if (self.selectedRow == 1)
    {
        NSString* username = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kUserName]];
        if([username isEqualToString:@"username"])
        {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Update Username" message:@"To be a part of the Global High Scores Table, you need to update your \"username\" in the Settings, or in the text field below." preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.keyboardType = UIKeyboardTypeDefault;
                textField.text = @"username";
            }];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *textField = [alert.textFields objectAtIndex:0];
                NSString *title = textField.text;
                
                
                [[NSUserDefaults standardUserDefaults] setObject:title forKey:kUserName];
            }]];
            
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else
        {
            [self performSegueWithIdentifier:@"showGlobalHighScoresVC" sender:self];
        }
    }
}

@end
