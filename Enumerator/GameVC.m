//
//  ViewController.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/9/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import "GameVC.h"

@implementation GameVC

-(void)viewWillAppear
{
    NSLog(@"view will appear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    db = [[DBManager alloc] init];

    
    screenSize = [UIScreen mainScreen].bounds.size;
    prefDict = [AppUtilities getPreferences];
    
    //GAME CONSTANTS
    beatCount = 0;
    fastFrameRate = 0.005;
    numOfLives = [[prefDict objectForKey:kNumOfLives] intValue];
    countIter = [[prefDict objectForKey:kCountIteration] intValue];
    factor1 = [[prefDict objectForKey:kFactor1] intValue]; //base mutliples
    factor2 = [[prefDict objectForKey:kFactor2] intValue];

    
    double frequency = [[prefDict objectForKey:kBeatsPerMinute] doubleValue];
    period = 60/frequency;
    bpm = frequency;
    gameType = [NSString stringWithFormat:@"%@",[prefDict objectForKey:kGameType]];
    
    [db openDatabase];
    
    NSMutableArray* dbArr = [db getScoreForFactor1:factor1 andFactor2:factor2 countIteration:countIter lives:numOfLives BPM:bpm andGameType:gameType];
    
    [db closeDatabase];
    
    if([dbArr count] > 0)
    {
        currentHighScore = [[dbArr objectAtIndex:0] intValue];
        NSLog(@"current High Score%d",currentHighScore);
    }
    

    [self addGameInterface];
    
    [self startGame];
}

-(void)addGameInterface
{
    gamePopulator = [[GameViewPopulator alloc] initPopulatorToView:self.view withScreenSize:screenSize inViewController:self withPrefDict:prefDict behindBackButton:backButton];
    
    //INFO BAR
    infoView = [gamePopulator makeInfoBarViewWithHighScore:currentHighScore];
    
    //MAKES THE COUNT LABLE
    countLabel = [gamePopulator makeCountLabel];
    
    //MAKE THE BUTTONS (ADDS THE IBACTION FUNCTION CALL)
    NSMutableArray* factorButtons = [gamePopulator makeFactorButtons:2];
    factorButton1 = [factorButtons objectAtIndex:0];
    factorButton2 = [factorButtons objectAtIndex:1];
    
    //LIFE BAR
    lifeBarArr = [gamePopulator makeLifeBarArray:numOfLives];
    
    metronome = [gamePopulator makeMetronomeImages:period andFastFrameRate:fastFrameRate];
}

//gets called to start timer, set life bars, and sets the count/iters/factors again
-(void)startGame
{
    //reset game numbers
    count = 0; //the current count shown on the screen
    iter1 = 0; //last value that was a mulitiple of the factor
    iter2 = 0;
    iter1Correct = NO; //boolean to tell if user missed an iteration count
    iter2Correct = NO;
    livesLeft = numOfLives;
    [countLabel setText:@"0"];

    theTimer = [NSTimer scheduledTimerWithTimeInterval:period target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
    metroTimer = [NSTimer scheduledTimerWithTimeInterval:fastFrameRate target:self selector:@selector(updateMetronome) userInfo:nil repeats:YES];
    
    //HIDE/SHOW BUTTONS FOR IN-GAME PLAY
    restartButton.hidden = YES;
    settingsButton.hidden = YES;
    homeButton.hidden = YES;
}

#pragma mark - Timer Methods
-(void)updateCounter
{
    count = count + countIter;
    factorButton1.backgroundColor = [UIColor whiteColor];
    factorButton2.backgroundColor = [UIColor whiteColor];
    [self resetMetronome];
    
    [countLabel setText:[NSString stringWithFormat:@"%d",count]];
    
    //update to a new iteration value for the user to correctly select
    if(count%factor1 == 0)
    {
        iter1 = count;
    }
    if(count%factor2 == 0)
    {
        iter2 = count;
    }
    
    //if the user does not select the correct iteration number, after the iteration count goes to the next value.
    if (iter1Correct == NO && count - countIter == iter1 && iter1 != 0)
    {
        [self looseALife];
    }
    else if (iter2Correct == NO && count - countIter == iter2 && iter2 != 0)
    {
        [self looseALife];
    }
    
    iter1Correct = NO;
    iter2Correct = NO;
}

-(void)updateMetronome
{
    beatCount = beatCount + 1;
    if (beatCount > [metronome count] -1) {
        beatCount = 0; //reset the metronome
    }
    [metronomeImage removeFromSuperview];
    metronomeImage = [metronome objectAtIndex:beatCount];
    [self.view insertSubview:metronomeImage aboveSubview:factorButton2];
}


#pragma mark - Button Actions
-(void)didPressFactorButton1
{
    if (count == iter1)
    {
        iter1Correct = YES;
        NSLog(@"correct"); //what if user taps multiple times between beats per minutes and gets a "correct" answer?
    }
    else
    {
        NSLog(@"WRONG");
        [self looseALife];
    }

    factorButton1.backgroundColor = [UIColor lightGrayColor];
}

-(void)didPressFactorButton2
{
    if (count == iter2)
    {
        iter2Correct = YES;
        NSLog(@"correct");
    }
    else
    {
        NSLog(@"WRONG");
        [self looseALife];
    }

    factorButton2.backgroundColor = [UIColor lightGrayColor];
}

-(IBAction)didPressReplayButton:(id)sender
{
    //hide the menu buttons
    backButton.hidden = NO; //shouldn't this be like a puase button?
    restartButton.hidden = YES;
    settingsButton.hidden = YES;
    homeButton.hidden = YES;
    
    //bring back game interface
    infoView.hidden = NO;
    countLabel.hidden = NO;
    factorButton1.hidden = NO;
    factorButton2.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self resetLifeBar];
    [scoreView removeFromSuperview];
    
    //restart the count/iterations/timers/lives
    [self startGame];
}

#pragma mark - Game Over / Restart
-(void)looseALife
{
    livesLeft = livesLeft - 1;
    
    if(livesLeft == -1)
    {
        //you loose!
        count = count - 1; //the count increases one more time after failure, this is the correction for that
        [self gameOver];
        
        return;
    }
    UIImageView* lifeBar = [lifeBarArr objectAtIndex:livesLeft];
    lifeBar.hidden = YES;
}

-(void)resetLifeBar
{
    for(UIImageView* lifeBar in lifeBarArr)
    {
        lifeBar.hidden = NO;
    }
}

-(void)resetMetronome
{
    beatCount = 0;
    [metronomeImage removeFromSuperview];
    if([metronome count] > 0)
    {
        [self.view insertSubview:[metronome objectAtIndex:0] aboveSubview:factorButton2];
    }
}

//what about beating your high schore?
//also show the score after when? or is just the number you got to?
-(void)gameOver
{
    infoView.hidden = YES;
    countLabel.hidden = YES;
    factorButton1.hidden = YES;
    factorButton2.hidden = YES;
    [metronomeImage removeFromSuperview];
    
    [theTimer invalidate];
    [metroTimer invalidate];
    
    backButton.hidden = YES;
    restartButton.hidden = NO;
    settingsButton.hidden = NO;
    homeButton.hidden = NO;
    
    [db openDatabase];
    
    NSMutableArray* dbArr = [db getScoreForFactor1:factor1 andFactor2:factor2 countIteration:countIter lives:numOfLives BPM:bpm andGameType:gameType];
    
    [db closeDatabase];
    
    //alert user if high score is reached
    if([dbArr count] == 0)
    {
        //check for username != 'username', throw up keyboard for username to post to global scores
        [db openDatabase];
        [db addScore:count factor1:factor1 factor2:factor2 count:countIter lives:numOfLives BPM:bpm gameType:gameType];
        [db closeDatabase];
        
        HighScoreDataHandler* hsDataHandler = [[HighScoreDataHandler alloc] init];
        [hsDataHandler postAHighScore:count];
    }
    else if(count > currentHighScore)
    {
        //check for username != 'username', throw up keyboard for username to post to global scores
        [db openDatabase];
        [db updateScore:count ForFactor1:factor1 andFactor2:factor2 countIteration:countIter lives:numOfLives BPM:bpm andGameType:gameType];
        [db closeDatabase];
        
        HighScoreDataHandler* hsDataHandler = [[HighScoreDataHandler alloc] init];
        [hsDataHandler postAHighScore:count];
    }

    
    int scored = [self findScore];
    NSLog(@"oldscore %d vs new %d",count, scored);
    
    //update current highscore to posting?
    //tell user highscore was achieved
    scoreView = [gamePopulator makeScoreBox:count withCurrentHighScore:currentHighScore];

}

-(int)findScore
{
    int scored = 0.3*count + 0.5*bpm - 0.2*numOfLives;
    return scored;
}

@end
