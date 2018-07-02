//
//  UserHighScoresVC.m
//  Enumerator
//
//  Created by Dylan Shackelford on 1/3/17.
//  Copyright © 2017 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserHighScoresVC.h"

typedef enum
{
    dbCol_factor1 = 0,
    dbCol_factor2 = 1,
    dbCol_score = 2,
    dbCol_countIteration = 3,
    dbCol_lives = 4,
    dbCol_BPM = 5,
    dbCol_gameType = 6,
}HighScoresDBColumn;


@implementation UserHighScoresVC

-(void)viewDidLoad
{
    db = [[DBManager alloc] init];
    [db openDatabase];
    
    NSMutableArray* dbArray = [db getAllScores]; //gets the users scores;
    tableData = [NSArray arrayWithArray:dbArray];
    [db closeDatabase];
    
    [super viewDidLoad];
    screenSize = [UIScreen mainScreen].bounds.size;
    self.navigationItem.title = [NSString stringWithFormat: @"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserName]];
    backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    self.navigationItem.leftBarButtonItem.title = @"Done";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)removeLoadingScreen
{
    [actInd stopAnimating];
    [loadingView removeFromSuperview];
}

#pragma mark - Table View Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return [sectionNames count]; //maybe each section is based off factors used
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //need to figure out how many scores in this section, not some static number
    return [tableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40; // you can have your own choice, of course
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    UILabel* factorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 50)];
    factorLabel.text = [NSString stringWithFormat:@"factors"];
    factorLabel.font = [UIFont systemFontOfSize:22];
    [headerView addSubview: factorLabel];
    
    UILabel* scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 75, 0, 200, 50)];
    scoreLabel.text = @"Score";
    scoreLabel.font = [UIFont systemFontOfSize:22];
    [headerView addSubview: scoreLabel];
    
    headerView.backgroundColor = [UIColor colorWithRed:215.f/255.0 green:215.f/255.0 blue:215.f/255.0 alpha:1];
    
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];

    NSString* factorStr = [NSString stringWithFormat:@"%@ | %@",[[tableData objectAtIndex:indexPath.row] objectAtIndex:dbCol_factor1],[[tableData objectAtIndex:indexPath.row] objectAtIndex:dbCol_factor2]];
    NSLog(@"%@",factorStr);
    cell.textLabel.text = factorStr;
    
    NSString* scoreStr = [NSString stringWithFormat:@"%@",[[tableData objectAtIndex:indexPath.row] objectAtIndex:dbCol_score]];
    UILabel* accLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 40)];
    accLabel.text = scoreStr;
    
    [cell addSubview:accLabel];
    [cell setAccessoryView:accLabel];
    
    return cell;
}

@end
