//
//  DBManager.h
//  watcher
//
//  Created by Alex on 11/22/14.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#ifndef watcher_DBManager_h
#define watcher_DBManager_h

#import <Foundation/Foundation.h>

@interface DBManager : NSObject


+(NSString*)getHotnessForSubject:(NSString*)subject Number:(NSString*)number Type:(NSString*)type Section:(NSString*)section Term:(NSString*) myTerm;

+(void)submitWatchForSubject:(NSString*)subject Number:(NSString*)number Type:(NSString*)type Section:(NSString*)section Term:(NSString*) myTerm;

+(void)submitNotificationForSubject:(NSString*)subject Number:(NSString*)number Type:(NSString*)type Section:(NSString*)section;

@end


#endif
