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

//+(NSArray*)getHighScoresForFactors:(int)factors
//{
//    NSString* factorStr = [NSString stringWithFormat:@"%d",factors];
//    
//    NSString* stringURL = [NSString stringWithFormat:@"http://dshacktech.com/getScores.php"];
//    
//    NSURL* theURL = [NSURL URLWithString:stringURL];
//    
//    NSArray* dataArray = [[NSArray alloc] init];
//    
//    NSURLSession* session =[NSURLSession sharedSession];
//    NSURLSessionDataTask* dataTask = [session dataTaskWithURL:m completionHandler:<#^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)completionHandler#>]
//    
//    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
//                                                   downloadTaskWithURL:theURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//                                                       // 3
//                                                       NSData* receivedData = [[NSData alloc] initWithContentsOfURL:theURL];
//                                                       NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:receivedData options:0 error:nil];
//                                                       dispatch_async(dispatch_get_main_queue(),^{
//                                                           dataArray = [jsonDict valueForKey:@"scores"];
////                                                           [self removeLoadingScreen];
////                                                           [self.tableView reloadData];
//                                                       });
//                                                       
//                                                   }];
//    
//    [downloadPhotoTask resume];
//    
//    return dataArray;
//}

@end
