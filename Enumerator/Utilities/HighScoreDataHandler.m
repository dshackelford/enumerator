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

-(id)initWithVC:(UIViewController *)vcInit
{
    self = [super init];
    
    self.vc = vcInit;
    
    return self;
}

-(void)getScoresForFactors:(NSString*)factorStr
{
    [self startSessionWithURL:[NSString stringWithFormat:@"http://dshacktech.com/enumerator/getScoresFromFactors.php?factors=%@",factorStr]];
}

-(void)getAllUserScores
{
    //assuming the user has already added a personal username
    NSString* username =[NSString stringWithFormat: @"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserName]];
    NSLog(@"%@",username);
    [self startSessionWithURL:[NSString stringWithFormat:@"http://dshacktech.com/enumerator/getScoresFromUsername.php?username=%@",username]];
}

//will retrun an ordered array of dictionaries that are at most 9 long, with the 10th item being the users scores?
-(void)getAllScores
{
    [self startSessionWithURL:@"http://dshacktech.com/enumerator/getAllScores.php"];
}

-(void)getTopScores
{
    //assuming the user has already added a personal username
    NSString* username =[NSString stringWithFormat: @"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserName]];
    [self startSessionWithURL:[NSString stringWithFormat:@"http://dshacktech.com/enumerator/getTopScores.php?username=%@",username]];
}

-(void)postAHighScore:(int)score
{
    NSString* username =[NSString stringWithFormat: @"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kUserName]];
    NSString* f1 = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kFactor1]];
    NSString* f2 = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kFactor2]];
    int countIter = [[[NSUserDefaults standardUserDefaults] objectForKey:kCountIteration] intValue];
    int lives = [[[NSUserDefaults standardUserDefaults] objectForKey:kNumOfLives] intValue];
    int bpm = [[[NSUserDefaults standardUserDefaults] objectForKey:kBeatsPerMinute] intValue];
    
    NSString* gameType = @"custom"; //need to keep this in the local settigns file??
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://dshacktech.com/enumerator/postScore.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *params =[NSString stringWithFormat:@"username=%@&factor1=%@&factor2=%@&score=%d&countIteration=%d&lives=%d&BPM=%d&gameType=%@",username,f1,f2,score,countIter,lives,bpm,gameType];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSLog(@"Data = %@", [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
    }];
    
    [dataTask resume];
}


-(void)updateUsernameChange:(NSString*)oldUsername toNewUsername:(NSString*)newUsername
{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://dshacktech.com/enumerator/updateUsername.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSString *params =[NSString stringWithFormat:@"newUsername=%@&oldUsername=%@",newUsername,oldUsername];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                       {
                                           NSLog(@"Data = %@", [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
                                       }];
    
    [dataTask resume];
}


-(void)startSessionWithURL:(NSString*)urlInit
{
    NSLog(@"%@",urlInit);
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.timeoutIntervalForRequest = 30; //30 second timeout interval
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:urlInit]];
    [downloadTask resume];
}

#pragma mark - NSURLSession Delegate Methods
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

// and here is the method for handling the response if it is an error
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(error)
        {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Web Error" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [[NSNotificationCenter defaultCenter] postNotificationName:nDidGetUserScores object:nil];
            }]];
            [self.vc presentViewController:alert animated:YES completion:nil];
            
        }else
        {
            //  the data was received in URLSession:dataTask:didReceiveData:
            //  the task has now ended, handle the response based on the received data
        }
    });
}

@end
