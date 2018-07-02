//
//  HomeVC.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/9/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeVC.h"
#import "GameVC.h"

@implementation HomeVC

-(void)viewDidLoad
{
    [super viewDidLoad];

    if(![[NSUserDefaults standardUserDefaults] objectForKey:kBeatsPerMinute])
    {
        [self initializeDefaults];
    }
    
}

-(void)initializeDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:60] forKey:kBeatsPerMinute];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:2] forKey:kFactor1];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:3] forKey:kFactor2];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:kCountIteration];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:5] forKey:kNumOfLives];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:60] forKey:];
//    [[NSUserDefaults standardUserDefaults] setObject:@"custom" forKey:kGameType];
}

-(void)didPressPlayButton:(id)sender
{
    
}

@end
