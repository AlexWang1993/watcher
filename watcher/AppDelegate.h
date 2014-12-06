//
//  AppDelegate.h
//  watcher
//
//  Created by Alex Wang on 1/31/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Setting.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) NSArray *shortList,*subjectList;

-(void)refreshBackground;

@property BOOL didRefresh;

@end
