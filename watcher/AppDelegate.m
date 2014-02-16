//
//  AppDelegate.m
//  watcher
//
//  Created by Alex Wang on 1/31/2014.
//  Copyright (c) 2014 Alex Wang. All rights reserved.
//

#import "AppDelegate.h"

#import "TableViewController.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   // UIImage *image =
 //   UIColor *background = [[UIColor alloc] initWithPatternImage:imageNamed:@"<#string#>"];
//    self.window.backgroundColor = background;
    // Override point for customization after application launch.
    NSUserDefaults* userDefaults=[NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"watcher_watchlist"]){
        _shortList=[userDefaults objectForKey:@"watcher_watchlist"];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //UIViewController* rootview=self.window.rootViewController;
    TableViewController *mainController=[((UINavigationController *) self.window.rootViewController).viewControllers objectAtIndex:0];
    /*for (id obj in [mainController.watchList objectAtIndex:0]){
        NSLog(@"%@",NSStringFromClass([obj  class]));
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:mainController.watchList] forKey:@"watcher_watchlist"];*/
    [[NSUserDefaults standardUserDefaults]setObject:[mainController generateShortList] forKey:@"watcher_watchlist"];
    [[NSUserDefaults standardUserDefaults]synchronize];

}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate *now=[NSDate date];
    localNotification.fireDate = now;
    localNotification.alertBody=@"HOHOHOHO";
    localNotification.soundName=UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    completionHandler(UIBackgroundFetchResultNewData);
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if ([self iOS_7]){
       [[UIApplication sharedApplication]setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    }
    return YES;
}

-(BOOL)iOS_7 {
    NSString *osVersion = @"7.0";
    NSString *currOsVersion = [[UIDevice currentDevice] systemVersion];
    return [currOsVersion compare:osVersion options:NSNumericSearch] == NSOrderedDescending;
}

@end
