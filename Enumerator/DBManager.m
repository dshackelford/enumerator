//
//  PossessionDatabase.m
//  Possession
//
//  Created by John Shackelford on 2/3/13.
//  Copyright (c) 2013 Tritera Incorporated. All rights reserved.
//

#import "DBManager.h"
#import "DBTableColumn.h"

typedef enum
{
    dbCol_factor1 = 0,
    dbCol_factor2 = 1,
    dbCol_score = 2,
    dbCol_countIteration = 3,
    dbCol_lives = 4,
    dbCol_BPM = 5,
    dbCol_gameType = 6,
}HighScoresDBColumn;


@implementation DBManager

-(id) init
{
    self = [super init];
    //These are the columns the database should have - just add new ones before the nil
    colNames = [NSArray arrayWithObjects:@"factor1",@"factor2",@"score",@"countIteration",@"lives",@"BPM",@"gameType", nil];
    
    return self;
}

#pragma mark - Database Management

// Open the database if it does not exist, create a new one.
- (Boolean)openDatabase
{
    Boolean openSuccess = [self openDatabaseSimple];
    if(openSuccess == false)
    {
        //Failed to open db so lets try to create a new one.
        Boolean createNewSuccess = [self createNewDatabase];
        if(createNewSuccess == true)
        {
            openSuccess = [self openDatabaseSimple];
            NSLog( @"Attempt to openDatabaseSimple after creating new returned %d", openSuccess);
            return true;
        }
        else
        {
            //Unable to create - something really out of wack
            return false;
        }
    }
    
    return true;
}

-(Boolean) openDatabaseSimple
{
    NSString* path = [self getActiveDatabaseFilePath];
    Boolean doesFileExist = [AppUtilities doesFileExistAtPath:path];
    if(doesFileExist == false)
    {
        return false;
    }
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK)
    {
        return true;
    }
    else
    {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(database);
        NSLog( @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
    return false;
    
}

//"PRAGMA table_info(tablename)"
-(NSMutableArray*) getActualListOfColumns
{
    NSString* sql = @"PRAGMA table_info(HighScores)";
    const char* sqlCstr = [sql UTF8String];
    
    NSMutableArray* results = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    
    // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
    // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
    if (sqlite3_prepare_v2(database, sqlCstr, -1, &statement, NULL) == SQLITE_OK)
    {
        // We "step" through the results - once for each row.
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            int colIndex = sqlite3_column_int(statement, 0);
            NSString* columnName = [NSString stringWithUTF8String: (char*)sqlite3_column_text(statement, 1)];
            NSString* columnType = [NSString stringWithUTF8String: (char*)sqlite3_column_text(statement, 2)];
            DBTableColumn* col = [[DBTableColumn alloc] init];
            [col setColumnName:columnName];
            [col setTypeName:columnType];
            [col setColumnNumber:colIndex];
            
            [results addObject:col];
#if !__has_feature(objc_arc)
            [col release];
#endif
        }
    }
    sqlite3_finalize(statement);
    
    return results;
}

////RETURNS THE NAMES OF THE COLUMNS IN A READABLE FORMAT
//-(NSMutableArray*) getDesignListOfColumns
//{
//    NSMutableArray* results = [[NSMutableArray alloc] init];
//    [results addObjectsFromArray:colNames];
//    
//    return results;
//}
//
//-(void) alterDbStructureAddMissingColumns
//{
//    NSMutableArray* currentCols;
//    [self openDatabaseSimple];
//    currentCols = [self getActualListOfColumns];
//    [self closeDatabase];
//    
//    NSUInteger colCount = [currentCols count];
//    NSUInteger designColCount = [colNames count];
//    if(colCount != designColCount)
//    {
//        NSLog(@"The existing database and the design database is out of sync!");
//        NSMutableArray* missingColNames = [self newGetListOfMissingColumns];
//        NSUInteger countOfMissingCols = [missingColNames count];
//        [self openDatabaseSimple];
//        for( int i = 0; i < countOfMissingCols; i++)
//        {
//            NSString* missingColName = [missingColNames objectAtIndex:i];
//            NSLog(@"Missing Column Name in Current database = %@", missingColName);
//            
//            if ([missingColName isEqualToString:[colNames objectAtIndex:dbCol_username]] == true)
//            {
//                [self alterDB_addSpotIDColumn];
//            }
//            else if([missingColName isEqualToString:[colNames objectAtIndex:dbCol_factor1]] == true)
//            {
//                [self alterDB_addSpotNameColumn];
//            }
//            else if([missingColName isEqualToString:[colNames objectAtIndex:dbCol_factor2]] == true)
//            {
//                [self alterDB_addSpotCountyColumn];
//            }
//            else if([missingColName isEqualToString:[colNames objectAtIndex:dbCol_score]] == true)
//            {
//                [self alterDB_addSpotLatColumn];
//            }
//            else if([missingColName isEqualToString:[colNames objectAtIndex:dbCol_countIteration]] == true)
//            {
//                [self alterDB_addSpotLonColumn];
//            }
//            else if([missingColName isEqualToString:[colNames objectAtIndex:dbCol_lives]] == true)
//            {
//                [self alterDB_addSpotFavoriteColumn];
//            }
//        }
//        [self closeDatabase];
//    }
//    else
//    {
//        NSLog(@"The existing database and the design database has the same number of columns");
//    }
//#if !__has_feature(objc_arc)
//    [currentCols release];
//#endif
//}
//
//-(NSMutableArray*) newGetListOfMissingColumns
//{
//    [self openDatabaseSimple];
//    NSMutableArray* currentCols;
//    NSMutableArray* currentColNames = [[NSMutableArray alloc] init ];
//    NSMutableArray* missingColumnNames = [[NSMutableArray alloc] init ];
//    
//    currentCols = [self getActualListOfColumns];//In the existing database
//    NSUInteger designColCount = [colNames count];
//    NSUInteger currentColCount = [currentCols count];
//    for(int i = 0; i < currentColCount; i++)
//    {
//        DBTableColumn* tableColumn = (DBTableColumn*)[currentCols objectAtIndex:i];
//        NSString* colName = [tableColumn getColumnName];
//        [currentColNames addObject:colName];
//    }
//    
//    for(int i = 0; i < designColCount; i++)
//    {
//        NSString* designColName = [colNames objectAtIndex:i];
//        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF like %@", designColName];
//        NSArray* missingItems = [currentColNames filteredArrayUsingPredicate: predicate];
//        if([missingItems count] < 1)
//        {
//            [missingColumnNames addObject:designColName];
//        }
//    }
//    [self closeDatabase];
//#if !__has_feature(objc_arc)
//    [currentCols release];
//#endif
//    return missingColumnNames;
//}

- (Boolean) closeDatabase
{
    int ret = sqlite3_close(database);
    if(ret == SQLITE_OK)
        return true;
    else
        return false;
}

-(NSString*) getActiveDatabaseFilePath
{
    NSString* pathToDB = [AppUtilities getPathToAppDatabase];
    return pathToDB;
}

- (Boolean)doesActiveDBFileExist
{
    Boolean exist;
    NSString* dbPath = [self getActiveDatabaseFilePath];
    NSLog(@"Database = %@", dbPath);
    
    exist = [AppUtilities doesFileExistAtPath:dbPath];
    return exist;
}

- (Boolean)createNewDatabase
{
    NSString* path = [AppUtilities getPathToAppDatabase];
    Boolean success = true;
    const char* dbpath = [path UTF8String];
    NSLog(@"Path to Database = %@",path);
    statusMessage = @"";
    
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        char *errMsg;

        const char* sql_stmt = "CREATE TABLE IF NOT EXISTS HighScores (factor1 int, factor2 int, score int, countIteration int, lives int, BPM int, gameType text)";
        
        if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            statusMessage = @"Failed to create HighScores table";
            success = false;
            NSLog(@"Failed to create HighScores table");
        }
        
        sqlite3_close(database);
    }
    else
    {
        statusMessage = @"Failed to open/create database";
        success = false;
    }
    // Even though the open failed, call close to properly clean up resources.
    sqlite3_close(database);
    return success;
}

#pragma mark - Column Updates
//-(Boolean) alterDB_addSpotIDColumn
//{
//    Boolean success = false;
//    NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE HighScores ADD COLUMN SpotID text;"];
//    success = [self executeQuery:updateSQL];
//    NSLog(@"Alter DB alterDB_addSpotIDColumn returned %@ on QUERY = %@", success ? @"TRUE" : @"FALSE", updateSQL);
//    return success;
//}
//
//-(Boolean) alterDB_addSpotNameColumn
//{
//    Boolean success = false;
//    NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE SpitcastSpots ADD COLUMN SpotName text;"];
//    success = [self executeQuery:updateSQL];
//    NSLog(@"Alter DB alterDB_addSpotNameColumn returned %@ on QUERY = %@", success ? @"TRUE" : @"FALSE", updateSQL);
//    return success;
//}
//
//-(Boolean) alterDB_addSpotCountyColumn
//{
//    Boolean success = false;
//    NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE SpitcastSpots ADD COLUMN SpotCounty text;"];
//    success = [self executeQuery:updateSQL];
//    NSLog(@"Alter DB alterDB_addSpotCountyColumn returned %@ on QUERY = %@", success ? @"TRUE" : @"FALSE", updateSQL);
//    return success;
//}
//
//-(Boolean) alterDB_addSpotLatColumn
//{
//    Boolean success = false;
//    NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE SpitcastSpots ADD COLUMN SpotLat double DEFAULT 0.0;"];
//    success = [self executeQuery:updateSQL];
//    NSLog(@"Alter DB alterDB_addSpotLatColumn returned %@ on QUERY = %@", success ? @"TRUE" : @"FALSE", updateSQL);
//    return success;
//}
//-(Boolean) alterDB_addSpotLonColumn
//{
//    Boolean success = false;
//    NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE SpitcastSpots ADD COLUMN SpotLon double DEFAULT 0.0;"];
//    success = [self executeQuery:updateSQL];
//    NSLog(@"Alter DB alterDB_addSpotLonColumn returned %@ on QUERY = %@", success ? @"TRUE" : @"FALSE", updateSQL);
//    return success;
//}
//-(Boolean) alterDB_addSpotFavoriteColumn
//{
//    Boolean success = false;
//    NSString *updateSQL = [NSString stringWithFormat: @"ALTER TABLE SpitcastSpots ADD COLUMN SpotFavorite boolean DEFAULT false;"];
//    success = [self executeQuery:updateSQL];
//    NSLog(@"Alter DB alterDB_addSpotFavoriteColumn returned %@ on QUERY = %@", success ? @"TRUE" : @"FALSE", updateSQL);
//    return success;
//}

-(Boolean)addScore:(int)score factor1:(int)factor1Init factor2:(int)factor2Init count:(int)countIter lives:(int)livesInit BPM:(int)BPMInit gameType:(NSString*)gameTypeStr
{
    NSMutableString* sql = [NSMutableString stringWithString:@"INSERT INTO HighScores "];
    
    [sql appendString:@"(factor1,factor2,score,countIteration,lives,BPM,gameType)"];
    [sql appendString:@" VALUES("];
    [sql appendFormat:@"'%d',",factor1Init];
    [sql appendFormat:@"'%d',",factor2Init];
    [sql appendFormat:@"'%d',",score];
    [sql appendFormat:@"'%d',",countIter];
    [sql appendFormat:@"'%d',",livesInit];
    [sql appendFormat:@"'%d',",BPMInit];
    [sql appendFormat:@"'%@'",gameTypeStr];
    [sql appendString:@" )"];
    
    
    sqlite3_stmt *insert_statement = nil;
    
    const char* sqlCstr = [sql UTF8String];
    if (sqlite3_prepare_v2(database, sqlCstr, -1, &insert_statement, NULL) != SQLITE_OK)
    {
        sqlite3_finalize(insert_statement);
        NSLog(@"SQLITE3_PREPARE FAILED %s", sqlite3_errmsg(database));
        return false;
    }
    
    if (sqlite3_step(insert_statement) != SQLITE_DONE)
    {
        NSLog(@"SQLITE3_STEP FAILED %s", sqlite3_errmsg(database));
    }
    
    sqlite3_finalize(insert_statement);
    return true;
}

#pragma mark - Basic Query
-(Boolean) executeQuery :(NSString*)sql
{
    const char* sqlCstr = [sql UTF8String];
    Boolean success = false;
    sqlite3_stmt *statement;
    
    // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
    // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
    if (sqlite3_prepare_v2(database, sqlCstr, -1, &statement, NULL) == SQLITE_OK)
    {
        //success = true;
        if(sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
    }
    sqlite3_finalize(statement);
    return success;
}


-(NSMutableArray*) executeQueryForAllColumns:(NSString*)sql
{
    const char* sqlCstr = [sql UTF8String];
    NSMutableArray* results = [[NSMutableArray alloc] init];
    //#endif
    
    sqlite3_stmt *statement;
    
    // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
    // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
    if (sqlite3_prepare_v2(database, sqlCstr, -1, &statement, NULL) == SQLITE_OK)
    {
        // "step" through the results - once for each row.
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            if(statement != nil)
            {
                NSMutableArray* rowArr = [[NSMutableArray alloc] init];
                for (int i=0; i<[colNames count]; i++)
                {
                    const unsigned char* st = sqlite3_column_text(statement, i);
                    [rowArr addObject:[NSString stringWithCString:st encoding:NSUTF8StringEncoding]];
                }
                
                [results addObject:rowArr];
            }
        }
    }
    sqlite3_finalize(statement);
    return results;
}

-(NSMutableArray*) executeQuery:(NSString*)sql forReturnOf:(HighScoresDBColumn)dbCol
{
    const char* sqlCstr = [sql UTF8String];
    NSMutableArray* results = [[NSMutableArray alloc] init];
    //#endif
    
    sqlite3_stmt *statement;
    
    // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
    // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
    if (sqlite3_prepare_v2(database, sqlCstr, -1, &statement, NULL) == SQLITE_OK)
    {
        // "step" through the results - once for each row.
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            if(statement != nil)
            {
                const unsigned char* st = sqlite3_column_text(statement, dbCol);
                [results addObject:[NSString stringWithCString:st encoding:NSUTF8StringEncoding]];
            }
        }
    }
    else
    {
        NSLog(@"SQLITE3_PREPARE FAILED %s", sqlite3_errmsg(database));
    }
    sqlite3_finalize(statement);
    return results;
    
}

-(Boolean)deleteAllScores
{
    NSString* sql = @"DELETE FROM HighScores";
    Boolean success = [self executeQuery:sql];
    return success;
}

-(NSMutableArray*)getAllScores
{
    NSString *sql = @"SELECT * FROM HighScores ORDER BY factor1 AND factor2";
    NSMutableArray* results = [self executeQueryForAllColumns:sql];
    
    return results;
}

-(NSMutableArray*)getScoreForFactor1:(int)factor1 andFactor2:(int)factor2 andGameType:(NSString*)gameTypeStr
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM HighScores WHERE factor1 = '%d' AND factor2 = '%d' AND gameType = '%@'", factor1,factor2,gameTypeStr];
    NSMutableArray* results = [self executeQuery:sql forReturnOf:dbCol_score];
    NSLog(@"%@",sql);
    return results;
}

-(Boolean)updateScore:(int)score ForFactor1:(int)factor1 andFactor2:(int)factor2 andGameType:(NSString*)gameTypeStr
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE HighScores SET score = '%d' WHERE factor1 = '%d' AND factor2 = '%d'AND gameType = '%@'", score, factor1,factor2,gameTypeStr];
    NSLog(@"update: %@",sql);
    
    return [self executeQuery:sql];

}

//-(NSMutableArray*)newGetAllCounties
//{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SpitcastSpots GROUP BY SpotCounty ORDER BY SpotLAT DESC"];
//
//    return [self executeQuery:sql forReturnOf:dbCol_factor2];
//}

//-(NSMutableArray*)newGetCountyFavorites
//{
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM SpitcastSpots WHERE SpotFavorite = 1 GROUP BY SpotCounty"];
//    
//    return [self executeQuery:sql forReturnOf:dbCol_factor2];
//}

//-(NSMutableArray*)getSpotNamesInCounty:(NSString*)countyInit
//{
//    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SpitcastSpots WHERE SpotCounty LIKE '%%%@%%' ORDER BY SpotLat DESC",countyInit];
////    NSString* sql = [NSString stringWithFormat:@"SELECT SpotName From SpitcastSpots WHERE SpotCounty = '%@' ORDER BY SpotLat DESC",countyInit];
//
////    NSLog(@"%@",sql);
//    return [self executeQuery:sql forReturnOf:dbCol_factor1];
//}
//
//-(NSMutableArray*)newGetSpotFavorites
//{
//    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SpitcastSpots WHERE SpotFavorite = 1"];
//    
////    NSLog(@"%@",sql);
//    return [self executeQuery:sql forReturnOf:dbCol_username];
//}
//
//-(NSMutableArray*)newGetSpotNameFavorites
//{
//    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SpitcastSpots WHERE SpotFavorite = 1"];
//    
////    NSLog(@"%@",sql);
//    return [self executeQuery:sql forReturnOf:dbCol_factor1];
//}
//
//
//-(NSString*)newGetCountyOfSpotID:(int)idInit
//{
//    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SpitcastSpots WHERE SpotID = %d",idInit];
//    
////    NSLog(@"%@",sql);
//    return [[self executeQuery:sql forReturnOf:dbCol_factor2] lastObject];
//}
//
//
//-(NSString*)newGetSpotNameOfSpotID:(int)idInit
//{
//    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SpitcastSpots WHERE SpotID = %d",idInit];
//    
//    //    NSLog(@"%@",sql);
//    return [[self executeQuery:sql forReturnOf:dbCol_factor1] lastObject];
//}
//
//-(CLLocation*)newGetLocationOfSpot:(int)idInit
//{
//    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM SpitcastSpots WHERE SpotID = %d",idInit];
//    
//    //    NSLog(@"%@",sql);
//    NSNumber* lat = [[self executeQuery:sql forReturnOf:dbCol_score] lastObject];
//    NSNumber* lon = [[self executeQuery:sql forReturnOf:dbCol_countIteration] lastObject];
//    
//    CLLocation* aLoc = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
//    return aLoc;
//}
//
//-(BOOL)setSpot:(NSString*)spotNameInit toFav:(BOOL)favInit
//{
//    NSString* sql;
//    
//    if (favInit == true)
//    {
//        sql = [NSString stringWithFormat:@"UPDATE SpitcastSpots SET SpotFavorite = 1 WHERE SpotName LIKE '%%%@%%'",spotNameInit];
//    }
//    else
//    {
//        sql = [NSString stringWithFormat:@"UPDATE SpitcastSpots SET SpotFavorite = 0 WHERE SpotName LIKE '%%%@%%'",spotNameInit];
//    }
//
////    NSLog(@"%@",sql);
//    return [self executeQuery:sql];
//}
//
//
//-(int)getCountOfAllSpots
//{
//    NSString *sql = @"SELECT * FROM SpitcastSpots";
//    const char* sqlCstr = [sql UTF8String];
//    sqlite3_stmt *statement;
//    int count = 0;
//    
//    // Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
//    // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.
//    if (sqlite3_prepare_v2(database, sqlCstr, -1, &statement, NULL) == SQLITE_OK)
//    {
//        // We "step" through the results - once for each row.
//        while (sqlite3_step(statement) == SQLITE_ROW)
//        {
//            count++;
//        }
//    }
//    sqlite3_finalize(statement);
//    return count;
//}




@end
