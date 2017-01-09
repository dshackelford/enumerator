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
    CGSize screenSize;
    
    UIView* loadingView;
    UIActivityIndicatorView* actInd;
    
    NSDictionary* prefDict;
    
}

-(void)grabHighScores;
-(void)didGetData:(NSNotification*)notification;

@end
