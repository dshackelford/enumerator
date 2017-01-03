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

@interface UserHighScoresVC : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITextView* textView;
    IBOutlet UIBarButtonItem* backButton;
    
    NSArray* tableData;
    NSMutableArray* sectionNames;
    NSMutableArray* sectionCount;
    CGSize screenSize;
    
    UIView* loadingView;
    UIActivityIndicatorView* actInd;
    
}

-(void)didGetData:(NSNotification*)notification;

@end
