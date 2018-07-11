//
//  BPMCell.h
//  Enumerator
//
//  Created by Dylan Shackelford on 12/10/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPMCell : UITableViewCell

@property IBOutlet UILabel* titleLabel;
@property IBOutlet UILabel* bpmCountLabel;
@property IBOutlet UISlider* slider;

@property IBOutlet UIButton* plusButton;
@property IBOutlet UIButton* minusButton;

-(IBAction)sliderChangedValue:(id)sender;
-(IBAction)editingDidEnd:(id)sender;

-(IBAction)didPressPlusButton:(id)sender;
-(IBAction)didPressMinusButton:(id)sender;

@end
