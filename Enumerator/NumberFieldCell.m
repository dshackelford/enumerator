//
//  NumberFieldCell.m
//  Enumerator
//
//  Created by Dylan Shackelford on 7/1/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NumberFieldCell.h"

@implementation NumberFieldCell

- (id)initWithPrefKey:(NSString*)prefKeyInit andTitleLabel:(NSString*)titleLabeInit
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TextFieldCell" owner:self options:nil] lastObject];
    self.prefKey = prefKeyInit;
    self.textField.delegate = self;
    self.textField.font = [UIFont systemFontOfSize:20];
    
    self.textLabel.text = titleLabeInit;
    self.textLabel.font = [UIFont systemFontOfSize:20];
    
    self.textField.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:self.prefKey]];
    
    return self;
}

@end
