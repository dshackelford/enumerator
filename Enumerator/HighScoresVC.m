//
//  HighScoresVC.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/13/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HighScoresVC.h"

@implementation HighScoresVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"High Scores";
    backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    self.navigationItem.leftBarButtonItem.title = @"Done";
    
    //call the php file to get the high scores
//    [self grabHighScores];
    //start the loading symbol for wait
}

-(void)grabHighScores
{
    NSString* stringURL = [NSString stringWithFormat:@"http://dshacktech.com/some.php?name=dshack"];
    
    NSURL* theURL = [NSURL URLWithString:stringURL];
    
    NSURLRequest* theRequest = [NSURLRequest requestWithURL:theURL];
    
    //MAKE THE CONNECTION TO THE INTERNET
    NSURLConnection* theConnection = [NSURLConnection connectionWithRequest:theRequest delegate:nil];
    //    NSURLSession
    
    [theConnection start];
    
    //COLLECT THE NECESSARY DATA
    NSData* receivedData = [[NSData alloc]initWithContentsOfURL:theURL];
    NSString* receivedString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",receivedString);
    
    textView.text = receivedString;

}
@end
