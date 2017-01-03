//
//  HighScoreDataHandler.h
//  Enumerator
//
//  Created by Dylan Shackelford on 12/21/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtilities.h"


@interface HighScoreDataHandler : NSObject <NSURLSessionDelegate,NSURLSessionDownloadDelegate>

@property NSDictionary* dataDict;
@property NSArray* dataArray;


-(void)getScoresForFactors:(NSString*)factorStr;
-(void)getAllScoresByFactors;
-(void)getAllUserScores;
-(void)getScoresForBPM:(NSString*)bpm;
-(void)postAHighScore:(int)score;

@end
