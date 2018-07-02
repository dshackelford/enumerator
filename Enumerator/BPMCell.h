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

-(IBAction)sliderChangedValue:(id)sender;
-(IBAction)editingDidEnd:(id)sender;
@end
