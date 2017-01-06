//
//  HighScoreDataHandler.m
//  Enumerator
//
//  Created by Dylan Shackelford on 12/21/16.
//  Copyright © 2016 Dylan Shackelford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HighScoreDataHandler.h"

@implementation HighScoreDataHandler

-(void)getScoresForFactors:(NSString*)factorStr
{
    [self startSessionWithURL:[NSString stringWithFormat:@"http://dshacktech.com/enumerator/getScoresFromFactors.php?factors=%@",factorStr]];
}

-(void)getAllUserScores
{
    //assuming the user has already added a personal username
    NSString* username =[NSString stringWithFormat: @"%@",[[AppUtilities getPreferences] objectForKey:kUserName]];
    NSLog(@"%@",username);
    [self startSessionWithURL:[NSString stringWithFormat:@"http://dshacktech.com/enumerator/getScoresFromUsername.php?username=%@",username]];
}

//will retrun an ordered array of dictionaries that are at most 9 long, with the 10th item being the users scores?
-(void)getAllScores
{
        [self startSessionWithURL:@"http://dshacktech.com/enumerator/getAllScores.php"];
}

-(void)postAHighScore:(int)score
{
    NSString* username =[NSString stringWithFormat: @"%@",[[AppUtilities getPreferences] objectForKey:kUserName]];
    NSString* f1 = [NSString stringWithFormat:@"%@",[[AppUtilities getPreferences] objectForKey:kFactor1]];
    NSString* f2 = [NSString stringWithFormat:@"%@",[[AppUtilities getPreferences] objectForKey:kFactor2]];
    int countIter = [[[AppUtilities getPreferences] objectForKey:kCountIteration] intValue];
    int lives = [[[AppUtilities getPreferences] objectForKey:kNumOfLives] intValue];
    int bpm = [[[AppUtilities getPreferences] objectForKey:kBeatsPerMinute] intValue];
    
    NSString* gameType = @"custom"; //need to keep this in the local settigns file??
    
    [self startSessionWithURL:[NSString stringWithFormat:@"http://dshacktech.com/enumerator/postScore.php?username=%@&factor1=%@&factor2=%@&score=%d&countIteration=%d&lives=%d&BPM=%d&gameType=%@",username,f1,f2,score,countIter,lives,bpm,gameType]];
}

-(void)startSessionWithURL:(NSString*)urlInit
{
    NSLog(@"%@",urlInit);
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:urlInit]];
    [downloadTask resume];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData *data = [NSData dataWithContentsOfURL:location];
    
    _dataArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    //post notification that the download is complete
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:nDidGetUserScores object:self];
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
//    float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //        [self.progressView setProgress:progress];
//    });
}

@end
