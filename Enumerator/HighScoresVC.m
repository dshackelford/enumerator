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
    
    tableData = @[@"Personal High Scores",@"Global High Scores"];
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
        [self performSegueWithIdentifier:@"showGlobalHighScoresVC" sender:self];
    }
}

////use this for passing information to the new view controller
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    //segmented control settings
//    if ([segue.identifier isEqualToString:@"showUserHighScoresVC"])
//    {
//        UserHighScoresVC *destViewController = segue.destinationViewController;
//        
////        [destViewController setTableData:[[NSMutableArray alloc] initWithArray:@[@"Height",@"Speed"]]];
////        NSMutableArray* segArray = [[NSMutableArray alloc] initWithArray:@[@[@"MPH",@"Kts"],@[@"ft",@"m"]]];
////        
////        [destViewController setSegControlArrays:segArray];
//        
////        NSString* title = [[tableData objectAtIndex:self.selectedSection] objectAtIndex:self.selectedRow];
////        NSLog(@"%@",title);
////        [destViewController setTitle:title];
//    }
//    else if([segue.identifier isEqualToString:@"showGlobalHighScoresVC"])
//    {
//        GlobalHighScoresVC *destViewController = segue.destinationViewController;
//        //                NSMutableArray* data = [[NSMutableArray alloc] initWithArray:@[@"Sunset Red",@"Seagrass Green",@"Ocean Blue",@"Sand Tan",@"Dawnpatrol Grey",]];
//        //            [destViewController setTableData:data];
////        [destViewController setTitle:@"Color Scheme"];
//        
//    }
//}

@end
