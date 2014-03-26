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
*/
@property (strong,atomic) NSDictionary *settings;

+ (Setting *)sharedInstance;

@end
