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
    [super viewDidLoad];
    screenSize = [UIScreen mainScreen].bounds.size;
    self.title = @"High Scores";
    backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    self.navigationItem.leftBarButtonItem.title = @"Done";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    tableData = nil; //to make the initial table delegate methods work
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                   ^{
                       [self grabHighScores];
                   });
    
    [self addLoadingScreen];
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

-(void)grabHighScores
{
    NSString* stringURL = [NSString stringWithFormat:@"http://dshacktech.com/getScores.php"];
    
    NSURL* theURL = [NSURL URLWithString:stringURL];
    
    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                   downloadTaskWithURL:theURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                       // 3
                                                       NSData* receivedData = [[NSData alloc] initWithContentsOfURL:theURL];
                                                       NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil];
                                                       dispatch_async(dispatch_get_main_queue(),^{
                                                           tableData = [jsonDict valueForKey:@"scores"];
                                                           [self removeLoadingScreen];
                                                           [self.tableView reloadData];
                                                       });
                                                       
                                                   }];
    
    [downloadPhotoTask resume];

}

#pragma mark - Table View Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; //maybe each section is based off factors used
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50; // you can have your own choice, of course
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    UILabel* userLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 150, 50)];
    userLabel.text = @"Username";
    userLabel.font = [UIFont systemFontOfSize:22];
    [headerView addSubview: userLabel];
    
    UILabel* scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 75, 0, 200, 50)];
    scoreLabel.text = @"Score";
    scoreLabel.font = [UIFont systemFontOfSize:22];
    [headerView addSubview: scoreLabel];
    
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* usernameStr = [NSString stringWithFormat:@"%@",[[tableData objectAtIndex:indexPath.row] valueForKey:kUserName]];
    NSString* scoreStr = [NSString stringWithFormat:@"%@",[[tableData objectAtIndex:indexPath.row] valueForKey:@"score"]];
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    cell.textLabel.text = usernameStr;
    
    UILabel* accLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 40)];
    accLabel.text = scoreStr;

    [cell addSubview:accLabel];
    [cell setAccessoryView:accLabel];
    
    return cell;
    
}
@end
