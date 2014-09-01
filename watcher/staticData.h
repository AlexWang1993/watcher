//
//  staticData.h
//  watcher
//
//  Created by Alex Wang on 2/9/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *apiKey=@"e2b51117475b5dd304155b436fe6787b";

static NSString *unlimitedAPIKey=@"884d9c5288743f49ab8e9ea578a50b25";

#define barColor [UIColor colorWithRed:149.0/256 green:196.0/256 blue:219.0/256 alpha:1]

#define barHighlightColor [UIColor colorWithRed:206.0/256 green:232.0/256 blue:245.0/256 alpha:1]

#define customFont [UIFont fontWithName:@"QuicksandBold-Regular" size:16.0f]

#define UWurl @"https://api.uwaterloo.ca/v2/"

#define LocalUrl @"/Users/alexwang/Documents/ClassWatcher/testjson/"

#define ApiUrl LocalUrl

#define coursesApiDir @"courses/"

#define codesApiDir @"codes/"

#define debug false


@interface staticData : NSObject




@end
