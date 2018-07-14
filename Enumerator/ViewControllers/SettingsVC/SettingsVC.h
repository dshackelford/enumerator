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
#import "TextFieldCell.h"
#import "NumberFieldCell.h"
#import "HighScoreDataHandler.h"

@interface SettingsVC : UITableViewController <UIPickerViewDelegate ,UIPickerViewDataSource, UIGestureRecognizerDelegate>
{
    NSArray* tableData;
    NSArray* tableNames;
        
    IBOutlet UIBarButtonItem* playButton;
    IBOutlet UIBarButtonItem* backButton;
    
    CGSize screenSize;
    
    
}
@property UIPickerView* picker;
@property NSArray* factorData;
@property NSArray* gameTypeNames;
@property UIButton* backgroundTapButton;

@property TextFieldCell* usernameCell;
@property NumberFieldCell* countIterationCell;
@property NumberFieldCell* numOfLivesCell;

@property BPMCell* bpmCell;

@property int tag;

@end
