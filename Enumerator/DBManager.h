//
//  PossessionDatabase.h
//  Possession
//
//  Created by John Shackelford on 2/3/13.
//  Copyright (c) 2013 Tritera Incorporated. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AppUtilities.h"
#import "CoreLocation/CoreLocation.h"

@interface DBManager : NSObject
{
    sqlite3* database;
    NSArray* colNames;
    NSString* statusMessage;
}

-(Boolean) openDatabase;
-(Boolean) openDatabaseSimple;
-(Boolean) closeDatabase;
-(NSMutableArray*) getActualListOfColumns;
-(NSMutableArray*) getDesignListOfColumns;
-(Boolean) createNewDatabase;

-(NSString*) getActiveDatabaseFilePath;
- (Boolean) doesActiveDBFileExist;

//-(NSMutableArray*) executeQuery:(NSString*)sql forReturnOf:(SurfShackDBColoumn)dbCol;


-(Boolean)deleteAllSpots;
-(NSMutableArray*)newGetAllSpots;
-(NSMutableArray*)newGetSomeSpots:(unsigned int)limit;
-(int)getCountOfAllSpots;
-(NSMutableArray*)newGetAllCounties;
-(NSMutableArray*)newGetCountyFavorites;
-(NSMutableArray*)getSpotNamesInCounty:(NSString*)countyInit;
-(CLLocation*)newGetLocationOfSpot:(int)idInit;
-(NSString*)newGetSpotNameOfSpotID:(int)idInit;
-(NSString*)getSpotNameOfID:(int)idInit;

-(BOOL)setSpot:(NSString*)spotNameInit toFav:(BOOL)favInit;
-(NSMutableArray*)newGetSpotFavorites;
-(NSMutableArray*)newGetSpotNameFavorites;
-(NSString*)newGetCountyOfSpotID:(int)idInit;

-(Boolean) deleteAllMatchReports;
-(Boolean) deleteMatchReports :(NSMutableArray*)matches;
-(Boolean) deleteMatchReportsUsingTimeStamps :(NSArray*)timeStamps;
-(void) recreateMatchEventsInMatchReports :(NSMutableArray*) results;

-(void) alterDbStructureAddMissingColumns;
-(NSMutableArray*) newGetListOfMissingColumns;
-(Boolean) alterDB_addSpotIDColumn;
-(Boolean) alterDB_addSpotNameColumn;
-(Boolean) alterDB_addSpotCountyColumn;
-(Boolean) alterDB_addSpotLatColumn;
-(Boolean) alterDB_addSpotLonColumn;
-(Boolean) alterDB_addSpotFavoriteColumn;




-(Boolean)addScore:(int)score factor1:(int)factor1Init factor2:(int)factor2Init count:(int)countIter lives:(int)livesInit BPM:(int)BPMInit gameType:(NSString*)gameTypeStr;

-(Boolean)deleteAllScores;
-(NSMutableArray*)getAllScores;
-(NSMutableArray*)getScoreForFactor1:(int)factor1 andFactor2:(int)factor2 andGameType:(NSString*)gameTypeStr;

-(Boolean)updateScore:(int)score ForFactor1:(int)factor1 andFactor2:(int)factor2 andGameType:(NSString*)gameTypeStr;


@end
