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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetData:) name:nDidGetData object:nil];
    
    [super viewDidLoad];
    screenSize = [UIScreen mainScreen].bounds.size;
    self.navigationItem.title = @"USER HIGH Scores";
    backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    self.navigationItem.leftBarButtonItem.title = @"Done";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    tableData = nil; //to make the initial table delegate methods work
    
//    [self addLoadingScreen];
    
//    [self grabHighScores];
}


-(void)grabHighScores
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                   ^{
                       HighScoreDataHandler* hsHandler = [[HighScoreDataHandler alloc] init];
                       //                       [hsHandler getScoresForFactors:[NSString stringWithFormat:urlGetHighScores]]; //needs to change!!!
                       [hsHandler getAllUserScores];
                       
                   });
}

//ON MAIN THREAD
-(void)didGetData:(NSNotification*)notification
{
    NSLog(@"Got data");
    HighScoreDataHandler* hsHandler = notification.object;
    NSLog(@"%@",hsHandler.dataArray);
    
    //    tableData = [hsHandler.dataDict objectForKey:@"scores"];
    //    tableData = hsHandler.dataArray; //an array ofdictionarys for each user/factors/scors/count etc..
    [self removeLoadingScreen];
    [self determineSectionNames:hsHandler.dataArray];
    [self.tableView reloadData];
}

-(void)determineSectionNames:(NSArray*)dataArrayInit
{
    
    //i know the names of each possible factors for the section title
    sectionNames = [[NSMutableArray alloc] init];
    [sectionNames addObject:[[tableData objectAtIndex:0] valueForKey:@"factors"]];
    sectionCount = [[NSMutableArray alloc] init];
    
    int count = 0;
    int scoreCount = 0;
    for(NSDictionary* userDict in tableData)
    {
        if(![[sectionNames objectAtIndex:count] isEqualToString:[userDict objectForKey:@"factors"]])
        {
            [sectionNames addObject:[userDict objectForKey:@"factors"]];
            count = count + 1;
            [sectionCount addObject:[NSNumber numberWithInt:sectionCount]];
            sectionCount = 0;
        }
        else
        {
            scoreCount = scoreCount + 1;
        }
    }
    
    //now i need to know how many scores are in each
    
    
}

-(void)addLoadingScreen
{
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,0, screenSize.width, screenSize.height)];
    //    loadingView.backgroundColor = [UIColor greenColor];
    
    actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [actInd setFrame:CGRectMake((screenSize.width/2 - 10), (screenSize.height/2 - 10), 20, 20)];
    
    UILabel *lblLoading = [[UILabel alloc] initWithFrame:CGRectMake((screenSize.width/2 - 75), (screenSize.height/2 + 15), 150, 30)];
    lblLoading.text = @"Loading";
    lblLoading.textAlignment = NSTextAlignmentCenter;
    
    // you will probably need to adjust those frame values to get it centered
    [actInd startAnimating];
    [loadingView addSubview:actInd];
    //    [loadingView addSubview:lblLoading];
    [self.view addSubview:loadingView];
}

-(void)removeLoadingScreen
{
    [actInd stopAnimating];
    [loadingView removeFromSuperview];
}

#pragma mark - Table View Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionNames count]; //maybe each section is based off factors used
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //need to figure out how many scores in this section, not some static number
    return [[sectionCount objectAtIndex:section] integerValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40; // you can have your own choice, of course
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    UILabel* userLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 50)];
    userLabel.text = [NSString stringWithFormat:@"%@",[sectionNames objectAtIndex:section]];
    //    userLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview: userLabel];
    
    //    UILabel* scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 75, 0, 200, 50)];
    //    scoreLabel.text = @"Score";
    //    scoreLabel.font = [UIFont systemFontOfSize:22];
    //    [headerView addSubview: scoreLabel];
    //
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* userDict = [tableData objectAtIndex:indexPath.row];
    
    NSString* usernameStr = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"username"]];
    NSString* scoreStr = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"highScore"]];
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    cell.textLabel.text = usernameStr;
    
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
