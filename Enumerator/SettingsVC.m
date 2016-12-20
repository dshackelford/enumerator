//
//  SettingsVC.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/9/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsVC.h"

@implementation SettingsVC
//
//typedef enum {
//    username,
//    bpm,
//    factor1,
//    factor2,
//    numOfFacs,
//    highScore
//    
//} keyIndex;

-(void)viewDidLoad
{
    NSLog(@"%@",[AppUtilities getPathToUserInfoFile]);
    
    screenSize = [UIScreen mainScreen].bounds.size;

    prefDict = [AppUtilities getPreferences];
    
    tableNames= @[@"Username",@"Beats Per Minute",@"Factors",@"Count Iteration",@"Lives",@"Factor Switch"];
    
    self.title = @"SETTINGS";
    self.tableView.backgroundColor = [UIColor colorWithRed:240/255.f green:240/255.f blue:240/255.f alpha:1];
    int tableHeight = (8)*45 + 2*50 + 100 + 70; //8 reg cells, 2 headers, 1 title bar, slider is 100 tall
    if(tableHeight > screenSize.height)
    {
        self.tableView.scrollEnabled = YES;
    }
    else
    {
        self.tableView.scrollEnabled = NO;
    }

    
    //removes the lines around cells not being used!
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
    
    playButton = [[UIBarButtonItem alloc] initWithTitle:@"Play" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem.title = @"Play";
    self.navigationItem.leftBarButtonItem.title = @"Done";
    
    _factorData = @[@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"],@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"]];
    
    _gameTypeNames = @[@"Adrenaline",@"Dyslexic",@"Crack Addict"];
}

//REMOVING THE KEYBOARD WHEN DONE EDITING
-(void) textFieldDidBeginEditing: (UITextField *) textField
{
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DismissKeyboard:)]];
}
-(void) DismissKeyboard:(UITapGestureRecognizer *) sender{
    [self.view endEditing:YES];
    [self.view removeGestureRecognizer:sender];
}

#pragma mark - UITableViewProtocols
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [tableNames count];
    }
    else
    {
        return [_gameTypeNames count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50; // you can have your own choice, of course
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if(indexPath.row != 1)
        {
            return 45;
        }
        else
        {
            return 100; //slider cell
        }
    }
    else
    {
        return 45;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Custom Settings";
    }
    else
    {
        return @"Game Types";
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //USERNAME, Count iteration, or lives
        if(indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4)
        {
            UsernameCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"UsernameCell" owner:self options:nil] lastObject];
            cell.textLabel.text = [tableNames objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:20];
            
            if (indexPath.row == 0) //username
            {
                cell.usernameTextField.text = [prefDict objectForKey:kUserName];
            }
            else if(indexPath.row == 3) //count iteration
            {
                cell.usernameTextField.text = [NSString stringWithFormat:@"%@",[prefDict objectForKey:kCountIteration]];
                cell.usernameTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
            else //lives number
            {
                cell.usernameTextField.text = [NSString stringWithFormat:@"%@",[prefDict objectForKey:kNumOfLives]];
                cell.usernameTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
            
            cell.usernameTextField.font = [UIFont systemFontOfSize:20];
            cell.usernameTextField.delegate = self;
            return cell;
        }
        //BEATS PER MINUTE SLIDER
        else if(indexPath.row == 1)
        {
            BPMCell* cell = [[[NSBundle mainBundle] loadNibNamed:@"BPMCell" owner:self options:nil] lastObject];
            //        cell.backgroundColor = [UIColor blueColor];
            cell.textLabel.text = [tableNames objectAtIndex:indexPath.row];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:20];
            
            cell.slider.tag = indexPath.row;
            
            [cell.slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventTouchCancel];
            
            [cell.slider addTarget:self action:@selector(editingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
            
            cell.slider.value = [[prefDict objectForKey:kBeatsPerMinute] intValue];
            cell.slider.maximumValue = 150;
            cell.slider.minimumValue = 10;
            cell.bpmCount.text = [NSString stringWithFormat:@"%@",[prefDict objectForKey:kBeatsPerMinute]];
            cell.bpmCount.font = [UIFont systemFontOfSize:20];
            return cell;
        }
        //FACTORS
        else if(indexPath.row == 2)
        {
            SubFactorsView* cell = [[[NSBundle mainBundle] loadNibNamed:@"SubFactorsView" owner:self options:nil] lastObject];
            
            cell.textLabel.text = [tableNames objectAtIndex:indexPath.row];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:20];
            
            cell.factorLabel1.text = [NSString stringWithFormat:@"%@",[prefDict objectForKey:kFactor1]];
            cell.factorLabel2.text = [NSString stringWithFormat:@"%@",[prefDict objectForKey:kFactor2]];
            return cell;
        }
        else
        {
            UITableViewCell* cell = [[UITableViewCell alloc] init];
            [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
            cell.textLabel.text = [tableNames objectAtIndex:indexPath.row];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:20];
            
            if (indexPath.row == 5)
            {
                UISwitch* aSwicth= [[UISwitch alloc] initWithFrame:CGRectZero];
                [cell addSubview:aSwicth];
                [cell setAccessoryView:aSwicth];
            }
            else
            {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator]; //the grey chevron
            }
            
            return cell;
        }
    }
    else //game type section
    {
        UITableViewCell* cell = [[UITableViewCell alloc] init];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        
        cell.textLabel.text = [_gameTypeNames objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        
        //ask the app preferences sheet what to do with thin, only allow one game to be checked
        if (indexPath.row == 0)
        {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        
        return cell;
    }
}


-(void)sliderValueChanged
{
    NSLog(@"2hadf");
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    _selectedRow = indexPath.row;
    
    if (indexPath.row == 0)
    {
//        [self performSelector:@selector(didPressRestartButton:) withObject:nil];
//        [self performSelector:@selector(playButtonTapped:) withObject:nil];
    }
    else if(indexPath.row == 2)
    {
        [self showPickerView];
    }
    else
    {
//        //go into another view controller
//        [self performSegueWithIdentifier:@"showDifficultyView" sender:self];
    }
    
}

#pragma mark - UIPickerView Delegate Methods
- (void)showPickerView
{
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenSize.height,screenSize.width , 0.4*screenSize.height)];
    self.picker.backgroundColor = [UIColor lightGrayColor];

    _picker.dataSource = self;
    _picker.delegate = self;
    _picker.showsSelectionIndicator = YES;
    [_picker selectRow:[[prefDict objectForKey:kFactor1] intValue] - 1 inComponent:0 animated:NO];
    [_picker selectRow:[[prefDict objectForKey:kFactor2] intValue] - 1 inComponent:1 animated:NO];
    
    [self.view addSubview:_picker];
    
//     Animate it moving up
    [UIView animateWithDuration:.3 animations:^{
        [_picker setCenter:CGPointMake(screenSize.width/2, screenSize.height - self.picker.frame.size.height/2)]; //148 seems to put it in place just right.
    } completion:^(BOOL finished) {
        // When done, place an invisible button on the view behind the picker, so if the
        // user "taps to dismiss" the picker, it will go away. Good user experience!
        self.backgroundTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundTapButton.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
        [_backgroundTapButton addTarget:self action:@selector(backgroundTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:_backgroundTapButton belowSubview:self.picker];
    }];
    
}

// And lastly, the method to hide the picker.  You should handle the picker changing
// in a method with UIControlEventValueChanged on the pickerview.
- (void)backgroundTapped:(id)sender {
    
    [UIView animateWithDuration:.3 animations:^{
        _picker.center = CGPointMake(screenSize.width/2, screenSize.height + _picker.frame.size.height/2);
    } completion:^(BOOL finished) {
        [_picker removeFromSuperview];
        self.picker = nil;
        [self.backgroundTapButton removeFromSuperview];
        self.backgroundTapButton = nil;
    }];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 15;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
//    NSLog(@"%@",_factorData[component][row]);
    return _factorData[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Picker choose: %@",[[_factorData objectAtIndex:component] objectAtIndex:row]);
    SubFactorsView* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if(component == 0)
    {
        cell.factorLabel1.text = _factorData[component][row];
    }
    else
    {
        cell.factorLabel2.text = _factorData[component][row];
    }

}

-(void)dataChanged
{
    NSLog(@"got a change!");
}



-(void)viewWillDisappear:(BOOL)animated
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:prefDict];

    //FACTORS SAVE
    SubFactorsView* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [dict setObject:cell.factorLabel1.text forKey:kFactor1];
    [dict setObject:cell.factorLabel2.text forKey:kFactor2];
    
    
    //BPM SAVE
    BPMCell* bpmcell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [dict setObject:bpmcell.bpmCount.text forKey:kBeatsPerMinute];
    
    //USERNAME SAVE
    UsernameCell* usrnameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [dict setObject:usrnameCell.usernameTextField.text forKey:kUserName];
    
    //COUNT ITER SAVE
    usrnameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [dict setObject:usrnameCell.usernameTextField.text forKey:kCountIteration];
    
    //NUMBER OF LIVES SAVE
    usrnameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    [dict setObject:usrnameCell.usernameTextField.text forKey:kNumOfLives];
    
    [dict writeToFile:[AppUtilities getPathToUserInfoFile] atomically:YES];
    
}


@end
