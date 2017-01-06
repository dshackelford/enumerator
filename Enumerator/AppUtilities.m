//
//  AppUtilities.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/9/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppUtilities.h"

@implementation AppUtilities

#pragma mark - File Utitlies

+(NSString*) getPathToAppDatabase
{
    NSString* basePath = NSHomeDirectory();
    
    NSString* newPath = [basePath stringByAppendingPathComponent:@"Documents/HighScores.sqlite"];
    return newPath;
}

+(NSDictionary*)getPreferences
{
    if ([AppUtilities doesFileExistAtPath:[AppUtilities getPathToUserInfoFile]] == NO)
    {
        return [self createPreferences];
    }
    
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:[AppUtilities getPathToUserInfoFile]];
    
    return dict;
}

//creates file with new user preferences
//returns the newly created dictionary for use
+(NSDictionary*)createPreferences
{
    NSFileManager* appInfo = [NSFileManager defaultManager];
    
    [appInfo createFileAtPath:[self getPathToUserInfoFile] contents:nil attributes:nil];
    
    //ADDING TO THE DICTIONARY SHOULD HAPPEN IN THE SETTINGS
    NSArray* keys = @[kUserName,kBeatsPerMinute,kFactor1,kFactor2,kNumberOfFactors,kHighScoreDict,kCountIteration,kNumOfLives];
    
    NSDictionary* highScoreDict = [[NSDictionary alloc] init]; //dictionary where each object is the highscore for the corresponding key which is factors from low to high!
    
    NSArray* objects = @[@"username",@60,@"2",@"3",@2,highScoreDict,@1,@5]; //the initial settings for a new user
    NSDictionary* myDictionary =[[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    [myDictionary writeToFile:[AppUtilities getPathToUserInfoFile] atomically:YES ];
    
    return myDictionary;
}

+(NSString*)getPathToUserInfoFile
{
    NSString* homeDirectoryString = NSHomeDirectory();
    NSString* pathToUserInfoFile = [homeDirectoryString stringByAppendingPathComponent:@"/Documents/userInfo"];
    NSLog(@"path to file:%@",pathToUserInfoFile);
    return pathToUserInfoFile;
}



+(BOOL)doesFileExistAtPath:(NSString *)path
{
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return exists;
}

@end
