//
//  SettingsVC.h
//  Enumerator
//
//  Created by Dylan Shackelford on 12/9/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtilities.h"

#import "BPMCell.h"
#import "SubFactorsView.h"
#import "UsernameCell.h"
#import "HighScoreDataHandler.h"

@interface SettingsVC : UITableViewController <UIPickerViewDelegate ,UIPickerViewDataSource, UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    NSArray* tableData;
    NSArray* tableNames;
    
    NSDictionary* prefDict;
    
    IBOutlet UIBarButtonItem* playButton;
    IBOutlet UIBarButtonItem* backButton;
    
    CGSize screenSize;
    
    
}
@property UIPickerView* picker;
@property NSArray* factorData;
@property NSArray* gameTypeNames;
@property UIButton* backgroundTapButton;
@property int tag;

@end
