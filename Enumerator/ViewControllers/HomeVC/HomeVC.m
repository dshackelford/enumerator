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
#import "DBHandler.h"

@implementation HomeVC

-(void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    NSString *documentPath = [paths objectAtIndex:0];
    NSLog(@"Documents Path: %@", documentPath);
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:kBeatsPerMinute])
    {
        [self initializeDefaults];
    }
    
    [DBHandler createHighScoresDB];
    
    [DBHandler updateScore:999 forFactor1:2 andFactor2:3 andGameType:@"custom"];
    
}

-(void)initializeDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:60] forKey:kBeatsPerMinute];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:2] forKey:kFactor1];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:3] forKey:kFactor2];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:kCountIteration];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:5] forKey:kNumOfLives];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:60] forKey:];
    [[NSUserDefaults standardUserDefaults] setObject:@"custom" forKey:kGameType];
}


-(void)initializeScoresDatabase
{
    
}

-(void)didPressPlayButton:(id)sender
{
    
}

@end
