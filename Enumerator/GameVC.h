//
//  ViewController.h
//  Enumerator
//
//  Created by Dylan Shackelford on 12/9/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtilities.h"
#import "GameViewPopulator.h"

@interface GameVC : UIViewController
{
    UIButton* factorButton1;
    UIButton* factorButton2;
    UILabel* countLabel;
    IBOutlet UIButton* backButton;
    UIView* infoView;
    UIView* scoreView;
    
    int count;
    int factor1;
    int factor2;
    int iter1;
    int iter2;
    int numOfLives;
    int countIter;
    int currentHighScore;
    
    double period;
    int livesLeft;
    int score;
    
    CGSize screenSize;
    
    NSMutableArray* lifeBarArr;
    NSTimer* theTimer;
    
    IBOutlet UIButton* restartButton;
    IBOutlet UIButton* settingsButton;
    IBOutlet UIButton* homeButton;
    
    BOOL iter1Correct;
    BOOL iter2Correct;
    
    NSDictionary* prefDict;
    NSMutableArray* metronome;
    NSTimer* metroTimer;
    
    int beatCount;
    UIImageView* metronomeImage;
    double fastFrameRate;
    
    BOOL restart;
    UIVisualEffectView *blurEffectView;
    GameViewPopulator* gamePopulator;
    
}
-(void)updateCounter;

-(IBAction)didPressReplayButton:(id)sender;

-(void)didPressFactorButton1;
-(void)didPressFactorButton2;

//-(IBAction)didPressPauseButton:(id)sender;
@end
