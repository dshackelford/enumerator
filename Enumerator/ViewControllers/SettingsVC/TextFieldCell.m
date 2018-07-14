//
//  TextFieldCell.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/17/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextFieldCell.h"

@implementation TextFieldCell

- (id)initWithPrefKey:(NSString*)prefKeyInit andTitleLabel:(NSString*)titleLabeInit
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil] lastObject];
    self.prefKey = prefKeyInit;
    self.textField.delegate = self;
    self.textField.font = [UIFont systemFontOfSize:20];
    
    self.textLabel.text = titleLabeInit;
    self.textLabel.font = [UIFont systemFontOfSize:20];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:self.prefKey])
    {
        self.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:self.prefKey];
    }
    else
    {
        self.textField.text = @"";
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:self.prefKey];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField endEditing:YES];
    return YES;
}

@end
