//
//  Header.h
//  Enumerator
//
//  Created by Dylan Shackelford on 7/1/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import <FMDB.h>

@interface DBHandler : NSObject

+(void)createHighScoresDB;

+(int)getHighScoreForFactor1:(int)factor1 andFactor2:(int)factor2 andGameType:(NSString*)gameType;

+(void)addScore:(int)score forFactor1:(int)factor1 andFactor2:(int)factor2 withCount:(int)countIter lives:(int)numOfLives BPM:(int)bpm andGameType:(NSString*)gameType;

+(void)updateScore:(int)score forFactor1:(int)factor1 andFactor2:(int)factor2 andGameType:(NSString*)gameType;

+(NSMutableArray*)getAllUserScores;

@end
#endif /* Header_h */
