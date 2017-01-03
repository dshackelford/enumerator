//
//  HighScoresVC.h
//  Enumerator
//
//  Created by Dylan Shackelford on 12/13/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GlobalHighScoresVC.h"
#import "UserHighScoresVC.h"


@interface HighScoresVC : UITableViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITextView* textView;
    IBOutlet UIBarButtonItem* backButton;
    
    NSArray* tableData;
    
}

@property int selectedRow;

-(void)grabHighScores;

@end
