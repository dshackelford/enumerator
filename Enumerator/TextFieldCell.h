//
//  TextFieldCell.h
//  Enumerator
//
//  Created by Dylan Shackelford on 12/17/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell <UITextFieldDelegate>

@property IBOutlet UITextField* textField;
@property NSString* prefKey;

- (id)initWithPrefKey:(NSString*)prefKeyInit andTitleLabel:(NSString*)titleLabeInit;

//-(IBAction)sliderChangedValue:(id)sender;
//-(IBAction)editingDidEnd:(id)sender;
@end
