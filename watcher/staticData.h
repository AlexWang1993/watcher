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


//yellow mode
//#define barColor [UIColor colorWithRed:149.0/256 green:196.0/256 blue:219.0/256 alpha:1]
//#define barHighlightColor [UIColor colorWithRed:206.0/256 green:232.0/256 blue:245.0/256 alpha:1]

//blue
//#define barColor [UIColor colorWithRed:3.0/256 green:54.0/256 blue:73.0/256 alpha:1]
//#define barHighlightColor [UIColor colorWithRed:206.0/256 green:232.0/256 blue:245.0/256 alpha:1]


//pink mode
//#define barColor [UIColor colorWithRed:249.0/256 green:205.0/256 blue:173.0/256 alpha:1]

//#define barHighlightColor [UIColor colorWithRed:254.0/256 green:67.0/256 blue:101.0/256 alpha:1]


//green
//#define barColor [UIColor colorWithRed:18.0/256 green:53.0/256 blue:85.0/256 alpha:1]
//#define barHighlightColor [UIColor colorWithRed:206.0/256 green:232.0/256 blue:245.0/256 alpha:1]


#define customFont [UIFont fontWithName:@"QuicksandBold-Regular" size:16.0f]

#define UWurl @"https://api.uwaterloo.ca/v2/"

#define LocalUrl @"/Users/alexwang/Documents/ClassWatcher/testjson/"

#define ApiUrl LocalUrl

#define coursesApiDir @"courses/"

#define codesApiDir @"codes/"

#define debug false


@interface staticData : NSObject




@end
