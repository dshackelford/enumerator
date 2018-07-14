//
//  HowToPlayVC.h
//  Enumerator
//
//  Created by Dylan Shackelford on 7/7/18.
//  Copyright © 2018 Dylan Shackelford. All rights reserved.
//

#ifndef HowToPlayVC_h
#define HowToPlayVC_h

#import <UIKit/UIKit.h>

@interface HowToPlayVC : UITableViewController <UITableViewDelegate,UITableViewDataSource>

@property NSArray* tableData;
@property NSArray* sectionTitles;

@end

#endif /* HowToPlayVC_h */
