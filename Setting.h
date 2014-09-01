//
//  Setting.h
//  watcher
//
//  Created by Alex Wang on 3/25/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject

/*Keys:                             Type:
watcherNotificationEnabled          bool
watcherBackgroundImage              String
color                               UIColor
*/
@property (strong,atomic) NSMutableDictionary *settings;

+ (Setting *)sharedInstance;

@end
