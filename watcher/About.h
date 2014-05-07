//
//  About.h
//  watcher
//
//  Created by Helen Jiang on 2014-05-06.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"

@interface About : UITableViewController


@property  Setting* setting;
@property (strong,nonatomic) NSArray *imageList;
extern NSString *backgroundSelected;

@end
