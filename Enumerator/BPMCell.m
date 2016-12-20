//
//  BPMCell.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/10/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPMCell.h"

@implementation BPMCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //intialization code
    }
//    
//    _slider.maximumValue = 1000;
//    _slider.minimumValue = 0;
//    _slid
//    [_slider setFrame:CGRectMake(0, 0, 150, 20)];
    
    _bpmCount.textAlignment = NSTextAlignmentCenter;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)sliderChangedValue:(id)sender
{
    self.bpmCount.text = [NSString stringWithFormat:@"%.f",_slider.value];
    
//    NSLog(@"new value %f",_slider.value);
}

-(IBAction)editingDidEnd:(id)sender
{
//    NSLog(@"set value %f",_slider.value);
}
@end
