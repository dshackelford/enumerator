//
//  UserHighScoresVC.h
//  Enumerator
//
//  Created by Dylan Shackelford on 1/3/17.
//  Copyright © 2017 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtilities.h"
#import "HighScoreDataHandler.h"
#import "DBManager.h"

@interface UserHighScoresVC : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITextView* textView;
    IBOutlet UIBarButtonItem* backButton;
    
    NSArray* tableData;
    CGSize screenSize;
    
    UIView* loadingView;
    UIActivityIndicatorView* actInd;
    
    NSDictionary* scoresDict;
    
    DBManager* db;
}


@end
