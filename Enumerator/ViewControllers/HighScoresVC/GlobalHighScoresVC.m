//
//  GlobalHighScoresVC.m
//  Enumerator
//
//  Created by Dylan Shackelford on 1/3/17.
//  Copyright © 2017 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalHighScoresVC.h"

@implementation GlobalHighScoresVC

-(void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetData:) name:nDidGetUserScores object:nil];
    
    [super viewDidLoad];
    screenSize = [UIScreen mainScreen].bounds.size;
    self.title = @"High Scores";
    backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    self.navigationItem.leftBarButtonItem.title = @"Done";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    tableData = [[NSMutableArray alloc] init];
    HighScoreDataHandler* hsHandler = [[HighScoreDataHandler alloc] initWithVC:self];
    [hsHandler getAllScores];
//    [hsHandler getTopScores];
        
    [self addLoadingScreen];
    
}

-(void)didGetData:(NSNotification*)notification
{
    if(notification.object != nil)
    {
        NSLog(@"Got data");
        HighScoreDataHandler* hsHandler = notification.object;
        NSLog(@"%@",hsHandler.dataArray);
        
        [self processDataIntoTableFormat:hsHandler.dataArray];
        [self findUserRanks];
        [self removeLoadingScreen];
        [self.tableView reloadData];
    }
    else
    {
        [self performSegueWithIdentifier:@"showHighScoresTable" sender:self];
    }
}

-(void)processDataIntoTableFormat:(NSArray*)dataArrayInit
{
    sectionNames = [[NSMutableArray alloc] init];
    int i = 0;
    
    while(i < [dataArrayInit count])
    {
        NSDictionary* userDictI = [dataArrayInit objectAtIndex:i];
        NSMutableArray* sectionRowDicts = [[NSMutableArray alloc]init];
        NSString* factorsI = [NSString stringWithFormat:@"%@%@",[userDictI objectForKey:@"factor1"],[userDictI objectForKey:@"factor2"]];
        
        for(int j = i; j < [dataArrayInit count]; j = j + 1)
        {
            NSDictionary* userDictJ = [dataArrayInit objectAtIndex:j];
            NSString* factorsJ = [NSString stringWithFormat:@"%@%@",[userDictJ objectForKey:@"factor1"],[userDictJ objectForKey:@"factor2"]];
            
            if([factorsI isEqualToString:factorsJ])
            {
                [sectionRowDicts addObject:userDictJ];
                
                if(j == [dataArrayInit count] - 1) //reached the last row in last section?
                {
                    i = (int)[dataArrayInit count];
                    break;
                }
            }
            else
            {
                i = j; //to get to the next section
                break;
            }
        }
        [sectionNames addObject:[NSString stringWithFormat:@"Factors: %@ | %@",[userDictI objectForKey:@"factor1"],[userDictI objectForKey:@"factor2"]]];
        NSLog(@"%@",sectionRowDicts);
        [tableData addObject:sectionRowDicts]; //all the rows for one section in an array
    }
}

-(void)findUserRanks
{
    NSString* username = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserName]];
    userRanks = [[NSMutableArray alloc] init];
    for(int i = 0; i < [tableData count]; i = i +1) //each section
    {
        NSArray* sectionArr = [tableData objectAtIndex:i];
        int userScore = 0;
        int rank = 0;
        
        //get the user's scores
        for(NSDictionary* rowDict in sectionArr)
        {
            rank = rank + 1;
            NSString* rowUsername = [NSString stringWithFormat:@"%@",[rowDict valueForKey:@"username"]];
            if([username isEqualToString:rowUsername])
            {
                userScore = [[rowDict objectForKey:@"score"]intValue];
                break;
            }
        }
        [userRanks addObject:[NSNumber numberWithInt:rank]];
    }
    
    //if the user ranks as a number greater then 9, then we need to add it, should be the same length as the sectionNames array
}

-(void)addLoadingScreen
{
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0,0, screenSize.width, screenSize.height)];
    
    actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [actInd setFrame:CGRectMake((screenSize.width/2 - 10), (screenSize.height/2 - 10), 20, 20)];
    
    UILabel *lblLoading = [[UILabel alloc] initWithFrame:CGRectMake((screenSize.width/2 - 75), (screenSize.height/2 + 15), 150, 30)];
    lblLoading.text = @"Loading";
    lblLoading.textAlignment = NSTextAlignmentCenter;
    
    // you will probably need to adjust those frame values to get it centered
    [actInd startAnimating];
    [loadingView addSubview:actInd];
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
    if([[tableData objectAtIndex:section] count] < 10)
    {
        return [[tableData objectAtIndex:section] count];
    }
    else
    {
        return 10;
    }
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

    [headerView addSubview: userLabel];
    
    UILabel* scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 75, 0, 200, 50)];
    scoreLabel.text = @"Score";
    scoreLabel.font = [UIFont systemFontOfSize:22];
    [headerView addSubview: scoreLabel];

    headerView.backgroundColor = [UIColor colorWithRed:215.f/255.0 green:215.f/255.0 blue:215.f/255.0 alpha:1];
    
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //i am only showing top ten scores, and if the users score is outside the top ten, i'll add it to the 10th spot
    if(indexPath.row == 9 && [[userRanks objectAtIndex:indexPath.section] intValue] > 10)
    {
        int index = [[userRanks objectAtIndex:indexPath.section] intValue];
        
        //our user is outside the top ten, so add it to the tenth spot, and we are in the tenth spot!
        NSDictionary* userDict = [[tableData objectAtIndex:indexPath.section] objectAtIndex:index-1];
        
        NSString* username = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"username"]];
        NSString* usernameStr = [NSString stringWithFormat:@"%d. %@",[[userRanks objectAtIndex:indexPath.section] intValue],username];
        
        NSString* scoreStr = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"score"]];
        
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        cell.textLabel.text = usernameStr;
        
        
        UILabel* accLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 40)];
        accLabel.text = scoreStr;
        
        [cell addSubview:accLabel];
        [cell setAccessoryView:accLabel];
        
        if ([username isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserName]])
        {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
            accLabel.font = [UIFont boldSystemFontOfSize:20];
        }
        
        return cell;
    }
    else
    {
        NSDictionary* userDict = [[tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        NSString* username = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"username"]];
        NSString* usernameStr = [NSString stringWithFormat:@"%d. %@",(int)indexPath.row + 1,username];
        
        NSString* scoreStr = [NSString stringWithFormat:@"%@",[userDict objectForKey:@"score"]];
        
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
        cell.textLabel.text = usernameStr;
        
        
        UILabel* accLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 40)];
        accLabel.text = scoreStr;
        
        [cell addSubview:accLabel];
        [cell setAccessoryView:accLabel];
        
        if ([username isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserName]])
        {
            cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
            accLabel.font = [UIFont boldSystemFontOfSize:20];
        }
        
        return cell;
    }
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didGetData" object:nil];
}
@end
