//
//  AppUtilities.h
//  Enumerator
//
//  Created by Dylan Shackelford on 12/9/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//
#define kUserName @"username"
#define kBeatsPerMinute @"BPM"
#define kFactor1 @"factor1"
#define kFactor2 @"factor2"
#define kNumberOfFactors @"numOfFactors"
#define kHighScore @"userHighScore"
#define kCountIteration @"countIteration"
#define kNumOfLives @"numberOfLives"

@interface AppUtilities : NSObject
{
    
}

+(NSString*)getPathToUserInfoFile;
+(NSDictionary*)getPreferences;

+(BOOL)doesFileExistAtPath: (NSString*)path;


@end
