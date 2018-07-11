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

-(void)viewDidLoad
{
    NSLog(@"%@",[AppUtilities getPathToUserInfoFile]);
    
    screenSize = [UIScreen mainScreen].bounds.size;
    
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
    self.navigationItem.leftBarButtonItem.title = @"Done";
    
    _factorData = @[@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"],@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15"]];
    
    _gameTypeNames = @[@"Adrenaline",@"Dyslexic",@"Crack Addict"];
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
            NSString* title = [tableNames objectAtIndex:indexPath.row];
            
            if (indexPath.row == 0) //username
            {
                self.usernameCell = [[TextFieldCell alloc] initWithPrefKey:kUserName andTitleLabel:title];
                return self.usernameCell;
            }
            else if(indexPath.row == 3) //count iteration
            {
                
                self.countIterationCell = [[NumberFieldCell alloc] initWithPrefKey:kCountIteration andTitleLabel:title];
            
                self.countIterationCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                return self.countIterationCell;
            }
            else //lives number
            {
                
                self.numOfLivesCell = [[NumberFieldCell alloc] initWithPrefKey:kNumOfLives andTitleLabel:title];
                
                self.numOfLivesCell.textField.keyboardType = UIKeyboardTypeNumberPad;
                return  self.numOfLivesCell;
            }
        }
        //BEATS PER MINUTE SLIDER
        else if(indexPath.row == 1)
        {
            self.bpmCell = [[BPMCell alloc] init];
        
            return self.bpmCell;
        }
        //FACTORS
        else if(indexPath.row == 2)
        {
            SubFactorsView* cell = [[[NSBundle mainBundle] loadNibNamed:@"SubFactorsView" owner:self options:nil] lastObject];
            
            cell.textLabel.text = [tableNames objectAtIndex:indexPath.row];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font = [UIFont systemFontOfSize:20];
            
            cell.factorLabel1.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kFactor1]];
            cell.factorLabel2.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kFactor2]];
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

    self.picker.dataSource = self;
    self.picker.delegate = self;
    self.picker.showsSelectionIndicator = YES;
    [self.picker selectRow:[[[NSUserDefaults standardUserDefaults] objectForKey:kFactor1] intValue] - 1 inComponent:0 animated:NO];
    [self.picker selectRow:[[[NSUserDefaults standardUserDefaults] objectForKey:kFactor2] intValue] - 1 inComponent:1 animated:NO];
    
    [self.view addSubview:self.picker];
    
//     Animate it moving up
    [UIView animateWithDuration:.3 animations:^{
        [self.picker setCenter:CGPointMake(self->screenSize.width/2, self->screenSize.height - self.picker.frame.size.height/2)]; //148 seems to put it in place just right.
    } completion:^(BOOL finished) {
        // When done, place an invisible button on the view behind the picker, so if the
        // user "taps to dismiss" the picker, it will go away. Good user experience!
        self.backgroundTapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.backgroundTapButton.frame = CGRectMake(0, 0, self->screenSize.width, self->screenSize.height);
        [self.backgroundTapButton addTarget:self action:@selector(backgroundTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:self.backgroundTapButton belowSubview:self.picker];
    }];
    
}



// And lastly, the method to hide the picker.  You should handle the picker changing
// in a method with UIControlEventValueChanged on the pickerview.
- (void)backgroundTapped:(id)sender {
    
    [UIView animateWithDuration:.3 animations:^{
        self.picker.center = CGPointMake(self->screenSize.width/2, self->screenSize.height + self.picker.frame.size.height/2);
    } completion:^(BOOL finished) {
        [self.picker removeFromSuperview];
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
        [[NSUserDefaults standardUserDefaults] setObject:cell.factorLabel1.text forKey:kFactor1];
    }
    else
    {
        cell.factorLabel2.text = _factorData[component][row];
        [[NSUserDefaults standardUserDefaults] setObject:cell.factorLabel2.text forKey:kFactor2];
    }

}


@end
