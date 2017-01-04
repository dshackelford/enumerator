//
//  UserHighScoresVC.m
//  Enumerator
//
//  Created by Dylan Shackelford on 1/3/17.
//  Copyright © 2017 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserHighScoresVC.h"

@implementation UserHighScoresVC

-(void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetData:) name:nDidGetUserScores object:nil];
    
    [super viewDidLoad];
    screenSize = [UIScreen mainScreen].bounds.size;
    self.navigationItem.title = [NSString stringWithFormat: @"%@",[[AppUtilities getPreferences] objectForKey:kUserName]];
    backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    self.navigationItem.leftBarButtonItem.title = @"Done";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    tableData = nil; //to make the initial table delegate methods work
    
//    [self addLoadingScreen];
    
    NSDictionary* prefDict = [AppUtilities getPreferences];
    scoresDict = [prefDict objectForKey:kHighScoreDict];
    tableData = [scoresDict allKeys];
    
//    HighScoreDataHandler* hsHnd = [[HighScoreDataHandler alloc] init];
//    [hsHnd getAllUserScores]; //goes into background, will recieve a notification when the download is complete, which will then display the information
    
}
//
////WILL RUN AFTER NOTIFCATION POSTED BY THE DATA HANDLER
//-(void)didGetData:(NSNotification*)notification
//{
//    NSLog(@"Got data");
//    HighScoreDataHandler* hsHandler = notification.object;
//    NSLog(@"%@",hsHandler.dataArray);
//    
//    tableData = hsHandler.dataArray; //an array ofdictionarys for each user/factors/scors/count etc..
//    [self.tableView reloadData];
//    
//    [self removeLoadingScreen];
//}

//-(void)addLoadingScreen
//{
//    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,0, screenSize.width, screenSize.height)];
//    //    loadingView.backgroundColor = [UIColor greenColor];
//    
//    actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [actInd setFrame:CGRectMake((screenSize.width/2 - 10), (screenSize.height/2 - 10), 20, 20)];
//    
//    UILabel *lblLoading = [[UILabel alloc] initWithFrame:CGRectMake((screenSize.width/2 - 75), (screenSize.height/2 + 15), 150, 30)];
//    lblLoading.text = @"Loading";
//    lblLoading.textAlignment = NSTextAlignmentCenter;
//    
//    // you will probably need to adjust those frame values to get it centered
//    [actInd startAnimating];
//    [loadingView addSubview:actInd];
//    //    [loadingView addSubview:lblLoading];
//    [self.view addSubview:loadingView];
//}

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
    
    headerView.backgroundColor = [UIColor colorWithRed:219/255 green:223/255 blue:228/255 alpha:0.1];
    
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary* userDict = [tableData objectAtIndex:indexPath.row];
    
    NSString* scoreStr = [NSString stringWithFormat:@"%@",[scoresDict objectForKey:[tableData objectAtIndex:indexPath.row]]];
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[tableData objectAtIndex:indexPath.row]];
    
    UILabel* accLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 40)];
    accLabel.text = scoreStr;
    
    [cell addSubview:accLabel];
    [cell setAccessoryView:accLabel];
    
    return cell;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didGetData" object:nil];
}
@end
