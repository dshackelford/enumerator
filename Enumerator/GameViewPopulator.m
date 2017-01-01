//
//  GameViewPopulator.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/19/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewPopulator.h"

@implementation GameViewPopulator

-(id)initPopulatorToView:(UIView*)viewInit withScreenSize:(CGSize)screenSizeInit inViewController:(UIViewController*)VC withPrefDict:(NSDictionary*)prefDictInit behindBackButton:(UIButton*)backButtonInit
{
    self = [super init];
    
    parentViewController = VC;
    theView = viewInit;
    screenSize = screenSizeInit;
    prefDict = prefDictInit;
    backButton = backButtonInit;
    
    //Info Bar view
    xInfo = 10;
    yInfo = 25; //to clear the wifi signal and time bar on iphone
    widthInfo = screenSize.width - 2*10;
    heightInfo = 0.1*screenSize.height;
    backButton.frame = CGRectMake(10, yInfo,75,heightInfo);
    
    //Life Bar
    widthLifeBar = screenSize.width;
    heightLifeBar = 25;
    xLifeBar = 0;
    yLifeBar = yInfo + heightInfo + 10; //the ten is for a buffer
    
    //Count View
    xCount = 0;
    yCount = yLifeBar + heightLifeBar; //to clear the wifi signal and time bar on iphone
    widthCount = screenSize.width;
    heightCount = 0.2*screenSize.height; //or 120
    
    //Metronome Images (center of images!!)
    xMetro = screenSize.width/2;
    yMetro = yCount + heightCount + 15;
    heightMetro = 5;
    
    //Factor Buttons (with all around buffer of 10 pixels)
    xFactor1 = 10;
    xFactor2 = screenSize.width/2 + 5; //this may change depending on number of factors
    yFactor1 = yMetro + heightMetro;
    yFactor2 = yFactor1;
    widthFactor1 = screenSize.width/2 - 10 - 5; //there is a ten gap on phone edges, and down the center
    widthFactor2 = widthFactor1;
    heightFactor1 = screenSize.height - yMetro + heightMetro - 2*10; //the two tens for edges
    heightFactor2 = heightFactor1;
    
    //ScoreBox
    widthScoreBox = 0.65*screenSize.width;
    heightScoreBox = 125;
    xScoreBox = screenSize.width/2 - widthScoreBox/2;
    yScoreBox = 0.15*screenSize.height;
                                     
    return self;
}


-(UIView*)makeInfoBarView
{
    UIView* infoView = [[UIView alloc] initWithFrame:CGRectMake(xInfo, yInfo, widthInfo, heightInfo)];
    infoView.backgroundColor = [UIColor lightGrayColor];
    infoView.layer.borderColor = [UIColor blackColor].CGColor;
    infoView.layer.borderWidth = 3;
    
    UITextView* infoTextView = [[UITextView alloc] initWithFrame:CGRectMake(widthInfo - 200,-3,200,heightInfo)];//200 are the width and height of the text box
    infoTextView.text = [NSString stringWithFormat:@"Beats/min: %@ \nHigh Score: %@",[prefDict objectForKey:kBeatsPerMinute],[prefDict objectForKey:kHighScore]];
    infoTextView.backgroundColor = [UIColor clearColor];
    infoTextView.textAlignment = NSTextAlignmentRight;
    infoTextView.editable = NO;
    infoTextView.font = [UIFont systemFontOfSize:20];
    [infoView addSubview:infoTextView];
    
    [parentViewController.view insertSubview:infoView belowSubview:backButton];
    
    return infoView;
}

-(UILabel*)makeCountLabel
{
    UILabel* countLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCount, yCount, widthCount, heightCount)];
    
    [countLabel setText:@"0"];
    countLabel.layer.borderWidth = 0;
    countLabel.font = [UIFont boldSystemFontOfSize:150];
    countLabel.textAlignment = NSTextAlignmentCenter;

    [parentViewController.view addSubview:countLabel];
    return countLabel;
}

-(NSMutableArray*)makeFactorButtons:(int)howMany
{
    UIButton* factorButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [factorButton1 setTitle:[NSString stringWithFormat:@"%@",[prefDict objectForKey:kFactor1]] forState:UIControlStateNormal];
    [factorButton1 addTarget:parentViewController action:@selector(didPressFactorButton1) forControlEvents:UIControlEventTouchUpInside];
    factorButton1.frame = CGRectMake(xFactor1,yFactor1,widthFactor1,heightFactor1);
    factorButton1.titleLabel.font = [UIFont boldSystemFontOfSize:55];
    factorButton1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [factorButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    factorButton1.layer.borderWidth = 3;
    
    UIButton* factorButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [factorButton2 setTitle:[NSString stringWithFormat:@"%@",[prefDict objectForKey:kFactor2]] forState:UIControlStateNormal];
    [factorButton2 addTarget:parentViewController action:@selector(didPressFactorButton2) forControlEvents:UIControlEventTouchUpInside];
    factorButton2.frame = CGRectMake(xFactor2,yFactor2,widthFactor2,heightFactor2);
    factorButton2.titleLabel.font = [UIFont boldSystemFontOfSize:55];
    factorButton2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [factorButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    factorButton2.layer.borderWidth = 3;
    
    NSMutableArray* arrOfButtons = [[NSMutableArray alloc] init];
    [arrOfButtons addObject:factorButton1];
    [arrOfButtons addObject:factorButton2];
    
    [parentViewController.view addSubview:factorButton1];
    [parentViewController.view addSubview:factorButton2];
    
    return arrOfButtons;
    
}

-(NSMutableArray*)makeLifeBarArray:(int)numLives
{
    NSMutableArray* lifeBarArr = [[NSMutableArray alloc] init];
    double barLength = (screenSize.width - 20)/numLives; //the 20 is for a 10 buffer on both sides
    
    for (int i = 0; i < numLives; i = i + 1)
    {
        CGRect aBarRect = CGRectMake(3, 3, barLength, heightLifeBar);
        UIImageView* barImageView = [self drawTile:aBarRect andBarLength:barLength];
        [barImageView setFrame:CGRectMake(i*barLength + 10, yLifeBar, barLength + 6 , heightLifeBar)]; //the constant 10 offset is for the boundrary
        [parentViewController.view addSubview:barImageView];
        [lifeBarArr addObject:barImageView];
    }
    
    return lifeBarArr;
}

-(NSMutableArray*)makeMetronomeImages:(double)period andFastFrameRate:(double)fastFrameRate
{
    //we know the interval of images to make a smooth animation
    double fastInterval = fastFrameRate; //secs for each image
    double numOfImages = period/(2*fastInterval);
    double metronomeLength = screenSize.width;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    
    //METRONOME EXPANDS
    for (int i = 0; i < numOfImages ; i=i+1)
    {
        CGRect rect = CGRectMake(0, 0, i/numOfImages*metronomeLength, heightMetro);
        UIImageView* im = [self drawTile:rect ofColor:[UIColor redColor] withBorder:NO];
        im.center = CGPointMake(xMetro,yMetro);
        [arr addObject:im];
    }
    [arr removeLastObject];
    //METRONOME CONTRACTS
    for (int i = numOfImages; i > 0 ; i=i-1)
    {
        CGRect rect = CGRectMake(0, 0, i/numOfImages*metronomeLength, heightMetro);
        UIImageView* im = [self drawTile:rect ofColor:[UIColor redColor] withBorder:NO];
        im.center = CGPointMake(xMetro,yMetro);
        [arr addObject:im];
    }
    
    return arr;
}

-(UIView*)makeScoreBox:(int)score
{
    UIView* scoreView = [[UIView alloc] initWithFrame:CGRectMake(xScoreBox, yScoreBox, widthScoreBox, heightScoreBox)];
    scoreView.layer.borderWidth = 5;
    scoreView.backgroundColor = [UIColor whiteColor];
    
    UITextView* scoreTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, scoreView.frame.size.width - 2*10,200 - 2*10)];
    scoreTextView.text = [NSString stringWithFormat:@"%@:%@ at %@BPM\nScore: %d\nHigh: %@",[prefDict objectForKey:kFactor1],[prefDict objectForKey:kFactor2],[prefDict objectForKey:kBeatsPerMinute],score,[prefDict objectForKey:kHighScore]];
    scoreTextView.font = [UIFont systemFontOfSize:25];
    scoreTextView.backgroundColor = [UIColor clearColor];
    
    [scoreView addSubview:scoreTextView];
    
    
    [parentViewController.view addSubview:scoreView];
    return scoreView;
}


#pragma Mark - Bezier Drawing
//need a way to remove tiles easily, make the array of tiles an attribute of this view, so i can easily just remove one
-(UIImageView*)drawTile:(CGRect)rectInit andBarLength:(double)barLengthInit
{
    int lineWidth = 5;
    //start the rect at 0,0 to draw all of it within the current context rect
    UIBezierPath* tilePath = [UIBezierPath bezierPathWithRect:rectInit];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(barLengthInit + 3*lineWidth, rectInit.size.height + 3*lineWidth), NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    
    tilePath.lineWidth = lineWidth;
    
    [tilePath stroke];
    [tilePath fill];
    
    UIImage *bezierImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //make the image view from the path drawn on the context
    UIImageView* bezierImageView = [[UIImageView alloc]initWithImage:bezierImage];
    
    return bezierImageView;
}

-(UIImageView*)drawTile:(CGRect)rectInit ofColor:(UIColor*)colorInit withBorder:(BOOL)border
{
    int lineWidth = 5;
    //start the rect at 0,0 to draw all of it within the current context rect
    UIBezierPath* tilePath = [UIBezierPath bezierPathWithRect:rectInit];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(rectInit.size.width, rectInit.size.height + 3*lineWidth), NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, colorInit.CGColor);
    
    tilePath.lineWidth = lineWidth;
    
    if (border)
    {
        [tilePath stroke];
    }
    
    [tilePath fill];
    
    UIImage *bezierImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //make the image view from the path drawn on the context
    UIImageView* bezierImageView = [[UIImageView alloc]initWithImage:bezierImage];
    
    return bezierImageView;
}

@end
