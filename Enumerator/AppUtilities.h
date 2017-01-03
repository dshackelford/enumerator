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
#define kHighScoreDict @"highScoreDict"
#define kCountIteration @"countIteration"
#define kNumOfLives @"numberOfLives"

#define urlGetHighScores @"http://dshacktech.com/getScores.php"
#define nDidGetData @"didGetData"
#define kPostHighScoresBaseURL @"http://dshacktech.com/getScores.php"

@interface AppUtilities : NSObject
{
    
}

+(NSString*)getPathToUserInfoFile;
+(NSDictionary*)getPreferences;

+(BOOL)doesFileExistAtPath: (NSString*)path;


@end
