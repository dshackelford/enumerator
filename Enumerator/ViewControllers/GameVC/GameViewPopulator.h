//
//  GameViewPopulator.h
//  Enumerator
//
//  Created by Dylan Shackelford on 12/19/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppUtilities.h"

@class GameVC;

@interface GameViewPopulator : NSObject
{
    GameVC* parentViewController;
    UIView* theView;
    CGSize screenSize;
    UIButton* backButton;
    NSString* factorKey;
    
    //Info Bar view
    double xInfo;
    double yInfo; //to clear the wifi signal and time bar on iphone
    double widthInfo;
    double heightInfo;
    
    //Count View
    double xCount;
    double yCount; //to clear the wifi signal and time bar on iphone
    double widthCount;
    double heightCount; //or 120
    
    //Life Bar
    double widthLifeBar;
    double heightLifeBar;
    double xLifeBar;
    double yLifeBar;
    
    //Factor Buttons
    double xFactor1;
    double xFactor2; //this may change depending on number of factors
    double yFactor1;
    double yFactor2;
    double widthFactor1;
    double widthFactor2;
    double heightFactor1;
    double heightFactor2;
    
    //Metronome Images (center of images)
    double xMetro;
    double yMetro;
    double heightMetro;
    
    //ScoreBox
    double xScoreBox;
    double yScoreBox;
    double widthScoreBox;
    double heightScoreBox;
}

-(id)initPopulatorToView:(UIView*)viewInit withScreenSize:(CGSize)screenSizeInit inViewController:(GameVC*)VC  behindBackButton:(UIButton*)backButtonInit;

-(UIView*)makeInfoBarViewWithHighScore:(int)highScore;
-(UILabel*)makeCountLabel;
-(NSMutableArray*)makeFactorButtons:(int)howMany;
-(NSMutableArray*)makeLifeBarArray:(int)numLives;
-(NSMutableArray*)makeMetronomeImages:(double)period andFastFrameRate:(double)fastFrameRate;
-(UIView*)makeScoreBox:(int)score withCurrentHighScore:(int)currentHighScore;

@end
