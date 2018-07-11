//
//  BPMCell.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/10/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPMCell.h"
#import "AppUtilities.h"

@implementation BPMCell

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"BPMCell" owner:self options:nil] lastObject];

    self.textLabel.text = @"Beats Per Minute";
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.font = [UIFont systemFontOfSize:20];
    
//    self.slider.tag = indexPath.row;
    
    self.slider.value = [[[NSUserDefaults standardUserDefaults] objectForKey:kBeatsPerMinute] intValue];
    self.slider.maximumValue = 150;
    self.slider.minimumValue = 10;
    
    self.bpmCountLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kBeatsPerMinute]];
    self.bpmCountLabel.font = [UIFont systemFontOfSize:20];
    
    self.bpmCountLabel.textAlignment = NSTextAlignmentCenter;
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)sliderChangedValue:(id)sender
{
    self.bpmCountLabel.text = [NSString stringWithFormat:@"%.f",_slider.value];
    
    NSInteger bpm = [self.bpmCountLabel.text integerValue];
    NSLog(@"bpm saved as %ld",(long)bpm);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:bpm] forKey:kBeatsPerMinute];
}

-(IBAction)editingDidEnd:(id)sender
{
    NSLog(@"set value %f",_slider.value);
}

-(IBAction)didPressPlusButton:(id)sender
{
    self.slider.value = self.slider.value + 1;
    [self sliderChangedValue:self];
}

-(IBAction)didPressMinusButton:(id)sender
{
    self.slider.value = self.slider.value - 1;
    [self sliderChangedValue:self];
}
@end
