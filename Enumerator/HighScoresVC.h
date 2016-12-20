//
//  HighScoresVC.h
//  Enumerator
//
//  Created by Dylan Shackelford on 12/13/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HighScoresVC : UITableViewController
{
    IBOutlet UITextView* textView;
    IBOutlet UIBarButtonItem* backButton;
    
    //should there be a table??
}

-(void)grabHighScores;

@end
