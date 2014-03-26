//
//  Setting.m
//  watcher
//
//  Created by Alex Wang on 3/25/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "Setting.h"

@implementation Setting

+ (Setting *)sharedInstance
{
    static Setting *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Setting alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

@end
