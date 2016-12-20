//
//  SubFactorsView.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/16/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubFactorsView.h"

@implementation SubFactorsView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //intialization code
    }

    self.factorLabel1.textAlignment = NSTextAlignmentCenter;
    self.factorLabel2.textAlignment = NSTextAlignmentCenter;
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//-(IBAction)sliderChangedValue:(id)sender
//{
//    self.bpmCount.text = [NSString stringWithFormat:@"%.f",_slider.value*100];
//    
//    NSLog(@"new value %f",_slider.value);
//}
//
//-(IBAction)editingDidEnd:(id)sender
//{
//    NSLog(@"set value %f",_slider.value);
//}
@end
