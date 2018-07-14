//
//  DBHandler.m
//  Enumerator
//
//  Created by Dylan Shackelford on 7/1/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHandler.h"
#import "AppUtilities.h"

@implementation DBHandler

+(void)createHighScoresDB
{
    FMDatabase* db = [[FMDatabase alloc] initWithPath:[AppUtilities getPathToAppDatabase]];
    
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS HighScores (factor1 int, factor2 int, score int, countIteration int, lives int, BPM int, gameType text)"];
    [db close];
}

+(int)getHighScoreForFactor1:(int)factor1 andFactor2:(int)factor2 andGameType:(NSString *)gameType
{
    NSString *sql = [NSString stringWithFormat:@"SELECT score FROM HighScores WHERE factor1 = '%d' AND factor2 = '%d' AND gameType = '%@'", factor1,factor2,gameType];
    
    FMDatabase* db = [[FMDatabase alloc] initWithPath:[AppUtilities getPathToAppDatabase]];
    
    int highScore = 0;
    
    [db open];
    FMResultSet* set = [db executeQuery:sql];
    while([set next])
    {
        highScore = [set intForColumn:@"score"];
    }
    [db close];
    
    return highScore;
}

+(void)addScore:(int)score forFactor1:(int)factor1 andFactor2:(int)factor2 withCount:(int)countIter lives:(int)numOfLives BPM:(int)bpm andGameType:(NSString *)gameType
{
    NSMutableString* sql = [NSMutableString stringWithString:@"INSERT INTO HighScores "];
    
    [sql appendString:@"(factor1,factor2,score,countIteration,lives,BPM,gameType)"];
    [sql appendString:@" VALUES("];
    [sql appendFormat:@"'%d',",factor1];
    [sql appendFormat:@"'%d',",factor2];
    [sql appendFormat:@"'%d',",score];
    [sql appendFormat:@"'%d',",countIter];
    [sql appendFormat:@"'%d',",numOfLives];
    [sql appendFormat:@"'%d',",bpm];
    [sql appendFormat:@"'%@'",gameType];
    [sql appendString:@" )"];
    
    FMDatabase* db = [[FMDatabase alloc] initWithPath:[AppUtilities getPathToAppDatabase]];
    NSLog(@"DBHandler: AddScore sql: %@",sql);
    [db open];
    [db executeUpdate:sql];
    [db close];
}

+(void)updateScore:(int)score forFactor1:(int)factor1 andFactor2:(int)factor2 andGameType:(NSString *)gameType
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE HighScores SET score = '%d' WHERE factor1 = '%d' AND factor2 = '%d'AND gameType = '%@'", score, factor1,factor2,gameType];
    NSLog(@"DBHandler: updateScore sql: %@",sql);
    
    FMDatabase* db = [[FMDatabase alloc] initWithPath:[AppUtilities getPathToAppDatabase]];

    [db open];
    [db executeUpdate:sql];
    [db close];
    
}

+(NSMutableArray*)getAllUserScores
{
    NSString* sql = @"SELECT * FROM HighScores ORDER BY factor1 AND factor2";
    NSLog(@"DBHandler: getAllUserScores sql: %@",sql);
    
    FMDatabase* db = [[FMDatabase alloc] initWithPath:[AppUtilities getPathToAppDatabase]];
    
    NSMutableArray* allScoresArr = [NSMutableArray array];
    
    [db open];
    FMResultSet* set = [db executeQuery:sql];
    while ([set next])
    {
        NSMutableArray* scoreArr = [NSMutableArray array];
        
        [scoreArr addObject:[NSNumber numberWithInteger:[set intForColumn:@"factor1"]]];
        [scoreArr addObject:[NSNumber numberWithInteger:[set intForColumn:@"factor2"]]];
        [scoreArr addObject:[NSNumber numberWithInteger:[set intForColumn:@"score"]]];
        [allScoresArr addObject:scoreArr];
    }
    [db close];
    
    return allScoresArr;
}

@end
