//
//  HighScoreDataHandler.h
//  Enumerator
//
//  Created by Dylan Shackelford on 12/21/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtilities.h"



@interface HighScoreDataHandler : NSObject <NSURLSessionDelegate,NSURLSessionDownloadDelegate, UIAlertViewDelegate>

@property NSArray* dataArray;
@property UIViewController* vc;

-(id)initWithVC:(UIViewController*)vcInit;

-(void)getScoresForFactors:(NSString*)factorStr;
//-(void)getAllScoresByFactors;
-(void)getAllUserScores;
-(void)getAllScores;
-(void)getTopScores;
//-(void)getScoresForBPM:(NSString*)bpm;
-(void)postAHighScore:(int)score;
-(void)updateUsernameChange:(NSString*)oldUsername toNewUsername:(NSString*)newUsername;

@end
