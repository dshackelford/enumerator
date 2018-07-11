//
//  HowToPlayVC.m
//  Enumerator
//
//  Created by Dylan Shackelford on 7/7/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HowToPlayVC.h"

@implementation HowToPlayVC

-(void)viewDidLoad
{
    self.tableData = @[@[@"Put your counting skills to the test! Find patterns with multiplication tables that only Enumerator and its pacing can provide."],@[
                       @"The main counter will increase at a certain rate (your Beats per Minute, BPM). Base factors in a black rectangle on the bottom portion of the screen. Tap base factors whenever the main counter is divisible by that factor."],
                       @[@"Beats Per Minute (BPM): Controls the rate the main counter increments at.\n\nFactors: The numbers to check if the main counter is divisible by. Factor groups cannot be the same number.\n\nCount Iteration: The value by which the main counter increments.\n\nLives: How many times you can miss a main counter divisibilty factor."],
                       @[@"Scoring is kind of a mixed bag in this game due to all the variables and game types. To best handle this, Enumerator keeps track of your highest count per factor set, iteration, and BPM."]];
    self.sectionTitles = @[@"Concept",@"How to Play",@"Dials and Knobs",@"Scoring"];
    //\n\nFactor Switch: Let Enumerator change the factors on the fly for a more interesting game...
}

#pragma mark - TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionTitles.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //need to figure out how many scores in this section, not some static number
    return [[self.tableData objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40; // you can have your own choice, of course
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    
    UILabel* factorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 50)];
    factorLabel.text = [self.sectionTitles objectAtIndex:section];
    factorLabel.font = [UIFont systemFontOfSize:22];
    [headerView addSubview: factorLabel];
    
//    UILabel* scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tableView.frame.size.width - 75, 0, 200, 50)];
//    scoreLabel.text = @"Score";
//    scoreLabel.font = [UIFont systemFontOfSize:22];
//    [headerView addSubview: scoreLabel];
    
    headerView.backgroundColor = [UIColor colorWithRed:215.f/255.0 green:215.f/255.0 blue:215.f/255.0 alpha:1];
    
    return headerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    
    cell.textLabel.text = [[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    cell.userInteractionEnabled = NO;
    return cell;
}


@end
