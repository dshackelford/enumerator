//
//  GlobalHighScoresVC.h
//  Enumerator
//
//  Created by Dylan Shackelford on 1/3/17.
//  Copyright © 2017 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtilities.h"
#import "HighScoreDataHandler.h"

@interface GlobalHighScoresVC : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITextView* textView;
    IBOutlet UIBarButtonItem* backButton;
    
    NSMutableArray* tableData;
    NSMutableArray* sectionNames;
    NSMutableArray* sectionCount;
    NSMutableArray* userRanks;
    CGSize screenSize;
    
    UIView* loadingView;
    UIActivityIndicatorView* actInd;
        
}

-(void)grabHighScores;
-(void)didGetData:(NSNotification*)notification;

@end
