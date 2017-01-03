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

-(void)postAHighScore:(int)score
{
    [self startSessionWithURL:@"http://dshacktech.com/enumerator/postScore.php?username=testUser&factors=12&highScore=27&countIteration=1"];
}

-(void)startSessionWithURL:(NSString*)urlInit
{
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
