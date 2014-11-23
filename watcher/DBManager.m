//
//  DBManager.m
//  watcher
//
//  Created by Alex on 11/22/14.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "DBManager.h"
#import "Setting.h"
#import <Foundation/Foundation.h>

@interface DBManager ()

@end


@implementation DBManager

NSString *const serverURL = @"http://watcher-waterlooapp.rhcloud.com";

+(NSNumber*)getHotnessForSubject:(NSString*)subject Number:(NSString*)number Type:(NSString*)type Section:(NSString*)section{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/get_hotness?subject=%@&number=%@&type=%@&section=%@", serverURL, subject, number, type, section]];
    NSData* JSONData = [NSData dataWithContentsOfURL:url];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@", dic);
    return [dic objectForKey:@"hotness"];
}

+(void)submitWatchForSubject:(NSString*)subject Number:(NSString*)number Type:(NSString*)type Section:(NSString*)section{
    NSString *uuid = [self getUUID];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/newwatch?uuid=%@&subject=%@&number=%@&type=%@&section=%@", serverURL, uuid, subject, number, type, section]];
    NSData* JSONData = [NSData dataWithContentsOfURL:url];
    
}

+(NSString *)getUUID
{
    Setting* setting = [Setting sharedInstance];
    if ([setting.settings objectForKey:@"UUID"]==nil){
        [setting.settings setObject:[[NSUUID UUID] UUIDString] forKey:@"UUID"];
    }
    return [setting.settings objectForKey:@"UUID"];
}

@end