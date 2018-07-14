//
//  HomeVC.h
//  Enumerator
//
//  Created by Dylan Shackelford on 12/9/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController
{
    IBOutlet UILabel* titleLabel;
    IBOutlet UIButton* playButton;
    IBOutlet UIButton* settingsButton;
    IBOutlet UIButton* scores;
}

-(IBAction)didPressPlayButton:(id)sender;


@end
